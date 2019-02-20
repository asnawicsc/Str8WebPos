defmodule WebposWeb.PageController do
  use WebposWeb, :controller
  require IEx

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def webhook_get(conn, params) do
    cond do
      params["key"] == nil ->
        send_resp(conn, 200, "please include key .")

      params["fields"] == nil ->
        send_resp(conn, 200, "please include sales id in field.")

      params["fields"] != nil and params["key"] != nil and params["code"] != nil ->
        branch = Repo.get_by(Restaurant, code: params["code"], key: params["key"])

        if branch != nil do
          case params["fields"] do
            "discount" ->
              get_scope_discounts(conn, branch.organization_id, params["code"])

            "staffs" ->
              get_scope_staffs(conn, branch.organization_id, params["code"])

            "sales_payment" ->
              sales_payment(conn, branch, params["code"], params)

            _ ->
              send_resp(conn, 200, "request not available. \n")
          end
        else
          send_resp(conn, 200, "branch doesnt exist. \n")
        end
    end
  end

  def sales_payment(conn, restaurant, code, params) do
    payment_list =
      Reports.list_sales_payment(params["start"], params["end"], restaurant.name)
      |> Enum.map(fn x -> Map.put(x, :name, restaurant.name) end)
      |> Poison.encode!()

    IO.inspect(payment_list)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, payment_list)
  end

  def get_scope_discounts(conn, organization_id, code) do
    rest = Repo.get_by(Restaurant, code: code)

    discount_data =
      Repo.all(
        from(
          d in Discount,
          left_join: r in RestDiscount,
          on: r.discount_id == d.id,
          where: r.rest_id == ^rest.id,
          select: %{
            name: d.name,
            description: d.description,
            category: d.category,
            disc_type: d.disc_type,
            amount: d.amount,
            requirements: d.requirements,
            targets: d.targets
          }
        )
      )

    IO.inspect(discount_data)
    discount_list = %{discounts: discount_data} |> Poison.encode!()

    send_resp(conn, 200, discount_list)
  end

  def get_scope_staffs(conn, organization_id, code) do
    staff_data =
      Repo.all(
        from(
          u in User,
          where: u.user_type == ^"Staff" and u.organization_id == ^organization_id,
          select: %{
            staff_id: u.id,
            staff_name: u.username,
            staff_pin: u.pin,
            staff_level: u.user_level
          }
        )
      )
      |> Enum.map(fn x -> Map.put(x, :staff_pin, String.to_integer(x.staff_pin)) end)

    staff_list = %{staffs: staff_data} |> Poison.encode!()

    send_resp(conn, 200, staff_list)
  end

  # def sales_details(conn, params) do
  #   conn
  #   |> put_resp_content_type("text/csv")
  #   |> put_resp_header(
  #     "content-disposition",
  #     "attachment; filename=\"Sales By Category.csv.csv\""
  #   )
  #   |> send_resp(200, csv_salesdetails(conn, params))
  # end

  def sales_by_category(conn, params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"Sales By Category.csv.csv\""
    )
    |> send_resp(200, csv_content(conn, params))
  end

  def sales_details(conn, params) do
    branch = Repo.get_by(Restaurant, code: params["branch"])

    # all = Reports.list_sales_details(params["start_date"], params["end_date"], branch.name)

    csv_header = [
      [
        'Date',
        'Branch',
        'Item Name',
        'Unit Price',
        'Sub Total',
        'Total Quantity'
      ]
    ]

    q =
      from(
        s in Sale,
        left_join: p in SalesDetail,
        on: s.salesid == p.salesid,
        where:
          s.salesdate >= ^params["start_date"] and s.salesdate <= ^params["end_date"] and
            s.rest_name == ^branch.name,
        select: [s.salesdate, s.rest_name, p.itemname, p.unit_price, p.sub_total, p.qty]
      )

    Repo.transaction(fn ->
      q
      |> Repo.stream()
      |> (fn stream -> Stream.concat(csv_header, stream) end).()
      |> CSV.encode()
      |> Enum.into(
        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header(
          "content-disposition",
          "attachment; filename=\"SalesDetails.csv\""
        )
        |> send_chunked(200)
      )
    end)
  end

  def csv_content(conn, params) do
    branch = Repo.get_by(Restaurant, code: params["branch"])

    all =
      Repo.all(
        from(
          sd in Webpos.Reports.SalesDetail,
          left_join: s in Webpos.Reports.Sale,
          on: s.salesid == sd.salesid,
          where:
            s.salesdate >= ^params["start_date"] and s.salesdate <= ^params["end_date"] and
              s.rest_name == ^branch.name,
          group_by: [s.salesdate, sd.itemname, s.rest_name],
          select: %{
            salesdate: s.salesdate,
            branch: s.rest_name,
            itemname: sd.itemname,
            sub_total: sum(sd.sub_total),
            qty: sum(sd.qty)
          }
        )
      )

    csv_content = [
      'Date',
      'Branch',
      'Item Name',
      'Total Quantity',
      'Sub Total'
    ]

    data =
      for item <- all do
        [item.salesdate, item.branch, item.itemname, item.qty, item.sub_total]
      end

    csv_content =
      List.insert_at(data, 0, csv_content)
      |> CSV.encode()
      |> Enum.to_list()
      |> to_string
  end

  def top_10_sales(conn, params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"Top 10 Sales.csv.csv\""
    )
    |> send_resp(200, csv_content_top_10_sales(conn, params))
  end

  def csv_content_top_10_sales(conn, params) do
    branch = Repo.get_by(Restaurant, code: params["branch"])

    all =
      Repo.all(
        from(
          sd in Webpos.Reports.SalesDetail,
          left_join: s in Webpos.Reports.Sale,
          on: s.salesid == sd.salesid,
          where:
            s.salesdate >= ^params["start_date"] and s.salesdate <= ^params["end_date"] and
              s.rest_name == ^branch.name,
          group_by: [sd.itemname],
          select: %{
            itemname: sd.itemname,
            sub_total: sum(sd.sub_total),
            qty: sum(sd.qty)
          }
        )
      )
      |> Enum.sort_by(fn x -> x.sub_total end)
      |> Enum.reverse()
      |> Enum.take(10)

    csv_content = [
      'Item Name',
      'Total Quantity',
      'Sub Total'
    ]

    data =
      for item <- all do
        [item.itemname, item.qty, item.sub_total]
      end

    csv_content =
      List.insert_at(data, 0, csv_content)
      |> CSV.encode()
      |> Enum.to_list()
      |> to_string
  end

  def hourly_sales(conn, params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"Hourly Sales.csv.csv\""
    )
    |> send_resp(200, csv_content_hourly_sales(conn, params))
  end

  def csv_content_hourly_sales(conn, params) do
    branch = Repo.get_by(Restaurant, code: params["branch"])

    all =
      Repo.all(
        from(
          sd in Webpos.Reports.SalesDetail,
          left_join: s in Webpos.Reports.Sale,
          on: s.salesid == sd.salesid,
          where:
            s.salesdate >= ^params["start_date"] and s.salesdate <= ^params["end_date"] and
              s.rest_name == ^branch.name,
          select: %{
            itemname: sd.itemname,
            sub_total: sd.sub_total,
            qty: sd.qty,
            salesdate: s.salesdate,
            salesdatetime: s.salesdatetime
          }
        )
      )

    start_date = Date.from_iso8601!(params["start_date"])

    end_date = Date.from_iso8601!(params["end_date"])

    days = 1..30
    hours = 1..24

    dat = Date.range(start_date, end_date)

    data =
      for date <- dat do
        string_date = date |> Date.to_string()

        all =
          for hour <- hours do
            time =
              all |> Enum.filter(fn x -> x.salesdatetime.hour == hour and x.salesdate == date end)

            all =
              if time == [] do
                [string_date, hour, 0, 0]
              else
                qty = time |> Enum.map(fn x -> x.qty end) |> Enum.sum()

                sub_total =
                  time
                  |> Enum.map(fn x -> Decimal.to_float(x.sub_total) end)
                  |> Enum.sum()

                [string_date, hour, qty, sub_total |> Float.round(2)]
              end

            all
          end

        all
      end

    for a <- data do
      csv_content = [
        'Date',
        'Hour',
        'Quantity',
        'Sub Total'
      ]

      csv_content =
        List.insert_at(a, 0, csv_content)
        |> CSV.encode()
        |> Enum.to_list()
        |> to_string
    end
  end

  def discountsales(conn, params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"Discount Sales.csv.csv\""
    )
    |> send_resp(200, csv_content_discount_sales(conn, params))
  end

  def csv_content_discount_sales(conn, params) do
    branch = Repo.get_by(Restaurant, code: params["branch"])

    all =
      Repo.all(
        from(
          s in Webpos.Reports.Sale,
          where:
            s.salesdate >= ^params["start_date"] and s.salesdate <= ^params["end_date"] and
              s.rest_name == ^branch.name and s.discount_name != "n/a",
          group_by: [s.salesdate, s.discount_name, s.discount_description],
          select: %{
            date: s.salesdate,
            discount_name: s.discount_name,
            discounted_amount: sum(s.discounted_amount),
            discount_description: s.discount_description
          }
        )
      )

    csv_content = [
      'Date',
      'Discount Name',
      'Discount Description',
      'Total Discount Amount'
    ]

    data =
      for item <- all do
        [item.date, item.discount_name, item.discount_description, item.discounted_amount]
      end

    csv_content =
      List.insert_at(data, 0, csv_content)
      |> CSV.encode()
      |> Enum.to_list()
      |> to_string
  end
end
