defmodule WebposWeb.PageController do
  use WebposWeb, :controller
  require IEx

  require Elixlsx

  alias Elixlsx.Sheet
  alias Elixlsx.Workbook
  require Integer

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

            "sales_details" ->
              sales_details(conn, params)

            "top_10_sales" ->
              top_10_sales(conn, params)

            "hourly_sales" ->
              hourly_sales(conn, params)

            "discountsales" ->
              discountsales(conn, params)

            _ ->
              send_resp(conn, 200, "request not available. \n")
          end
        else
          send_resp(conn, 200, "branch doesnt exist. \n")
        end
    end
  end

  def sheet_cell_insert(sheet, item) do
    sheet = sheet |> Sheet.set_cell(item |> elem(0), item |> elem(1))

    sheet
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

  def sales_by_category(conn, params) do
    branch = Repo.get_by(Restaurant, code: params["branch"])

    all =
      from(
        sd in Webpos.Reports.SalesDetail,
        left_join: s in Webpos.Reports.Sale,
        on: s.salesid == sd.salesid,
        where:
          s.salesdate >= ^params["start_date"] and s.salesdate <= ^params["end_date"] and
            s.rest_name == ^branch.name,
        group_by: [s.salesdate, sd.itemname, s.rest_name],
        select: [
          s.salesdate,
          s.rest_name,
          sd.itemname,
          sum(sd.sub_total),
          sum(sd.qty)
        ]
      )

    csv_header = [
      [
        'Date',
        'Branch',
        'Item Name',
        'Total Quantity',
        'Sub Total'
      ]
    ]

    if params["output"] == "csv" do
      Repo.transaction(fn ->
        all
        |> Repo.stream()
        |> (fn stream -> Stream.concat(csv_header, stream) end).()
        |> CSV.encode()
        |> Enum.into(
          conn
          |> put_resp_content_type("text/csv")
          |> put_resp_header(
            "content-disposition",
            "attachment; filename=\"Sales By Category.csv\""
          )
          |> send_chunked(200)
        )
      end)
    else
      list = all |> Repo.all() |> Poison.encode!()

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, list)
    end
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

    if params["output"] == "csv" do
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
    else
      list = q |> Repo.all() |> Poison.encode!()

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, list)
    end
  end

  def top_10_sales(conn, params) do
    branch = Repo.get_by(Restaurant, code: params["branch"])

    all =
      from(
        sd in Webpos.Reports.SalesDetail,
        left_join: s in Webpos.Reports.Sale,
        on: s.salesid == sd.salesid,
        where:
          s.salesdate >= ^params["start_date"] and s.salesdate <= ^params["end_date"] and
            s.rest_name == ^branch.name,
        group_by: [sd.itemname],
        order_by: [desc: sum(sd.sub_total)],
        select: [
          sd.itemname,
          sum(sd.sub_total),
          sum(sd.qty)
        ],
        limit: 10
      )

    csv_header = [
      [
        'Item Name',
        'Total Quantity',
        'Sub Total'
      ]
    ]

    if params["output"] == "csv" do
      Repo.transaction(fn ->
        all
        |> Repo.stream()
        |> (fn stream -> Stream.concat(csv_header, stream) end).()
        |> CSV.encode()
        |> Enum.into(
          conn
          |> put_resp_content_type("text/csv")
          |> put_resp_header(
            "content-disposition",
            "attachment; filename=\"Top 10 Sales.csv\""
          )
          |> send_chunked(200)
        )
      end)
    else
      list = all |> Repo.all() |> Poison.encode!()

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, list)
    end
  end

  def discountsales(conn, params) do
    branch = Repo.get_by(Restaurant, code: params["branch"])

    all =
      from(
        s in Webpos.Reports.Sale,
        where:
          s.salesdate >= ^params["start_date"] and s.salesdate <= ^params["end_date"] and
            s.rest_name == ^branch.name and s.discount_name != "n/a",
        group_by: [s.salesdate, s.discount_name, s.discount_description],
        select: [
          s.salesdate,
          s.discount_name,
          s.discount_description,
          sum(s.discounted_amount)
        ]
      )

    csv_header = [
      [
        'Date',
        'Discount Name',
        'Discount Description',
        'Total Discount Amount'
      ]
    ]

    if params["output"] == "csv" do
      Repo.transaction(fn ->
        all
        |> Repo.stream()
        |> (fn stream -> Stream.concat(csv_header, stream) end).()
        |> CSV.encode()
        |> Enum.into(
          conn
          |> put_resp_content_type("text/csv")
          |> put_resp_header(
            "content-disposition",
            "attachment; filename=\"Discount Sales.csv\""
          )
          |> send_chunked(200)
        )
      end)
    else
      list = all |> Repo.all() |> Poison.encode!()

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, list)
    end
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

    if params["output"] == "csv" do
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
    else
      list = data |> Poison.encode!()

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, list)
    end
  end

  def sales_info(start_date, end_date) do
    all =
      Repo.all(
        from(
          s in Webpos.Reports.Sale,
          group_by: [s.salesdate],
          where: s.salesdate >= ^start_date and s.salesdate <= ^end_date,
          select: %{
            date: s.salesdate,
            total_rm: sum(s.grand_total),
            pax: sum(s.pax)
          }
        )
      )

    sales_revenue =
      for item <- all do
        [
          Date.to_string(item.date),
          item.total_rm |> Decimal.to_float() |> Float.round(2)
        ]
      end

    no_cust =
      for item <- all do
        [Date.to_string(item.date), item.pax]
      end

    sales_per_cust =
      for item <- all do
        total_rm = item.total_rm |> Decimal.to_float()

        spc = total_rm / item.pax

        [Date.to_string(item.date), spc |> Float.round(2)]
      end

    %{a: sales_revenue, b: no_cust, c: sales_per_cust}
  end

  def data_info(start_date, end_date, scope) do
    all =
      case scope do
        "main" ->
          Repo.all(
            from(
              sd in Webpos.Reports.SalesDetail,
              left_join: s in Webpos.Reports.Sale,
              on: s.salesid == sd.salesid,
              group_by: [sd.itemname],
              order_by: [desc: sum(sd.sub_total)],
              where: s.salesdate >= ^start_date and s.salesdate <= ^end_date,
              select: %{
                name: sd.itemname(),
                total_rm: sum(sd.sub_total),
                total_qty: sum(sd.qty)
              },
              limit: 10
            )
          )

        "service_charge" ->
          all =
            Repo.all(
              from(
                s in Webpos.Reports.Sale,
                group_by: [s.salesdate],
                order_by: [desc: s.salesdate],
                where: s.salesdate >= ^start_date and s.salesdate <= ^end_date,
                select: %{
                  date: s.salesdate,
                  total_rm: sum(s.service_charge)
                }
              )
            )

          all =
            for item <- all do
              %{date: item.date |> Date.to_string(), total_rm: Decimal.to_float(item.total_rm)}
            end

        "sales_overview" ->
          all =
            Repo.all(
              from(
                sd in Webpos.Reports.SalesDetail,
                left_join: s in Webpos.Reports.Sale,
                on: s.salesid == sd.salesid,
                group_by: [s.salesdate],
                where: s.salesdate >= ^start_date and s.salesdate <= ^end_date,
                select: %{
                  date: s.salesdate,
                  sales_revenue: sum(s.grand_total),
                  discount_amount: sum(s.discounted_amount),
                  total_pax: sum(s.pax)
                }
              )
            )

          all =
            for item <- all do
              sales_per_customer = Decimal.to_float(item.sales_revenue) / item.total_pax

              %{
                a: item.date |> Date.to_string(),
                b: item.sales_revenue |> Decimal.to_float() |> Float.round(2),
                c: item.discount_amount |> Decimal.to_float() |> Float.round(2),
                d: item.total_pax,
                e: sales_per_customer |> Float.round(2)
              }
            end

        "sales_ranking" ->
          all =
            Repo.all(
              from(
                s in Webpos.Reports.Sale,
                left_join: r in Webpos.Reports.SalesDetail,
                on: s.salesid == r.salesid,
                where: s.salesdate >= ^start_date and s.salesdate <= ^end_date,
                select: %{
                  itemname: r.itemname,
                  qty: r.qty,
                  total: r.sub_total
                }
              )
            )

          item_name_list = all |> Enum.map(fn x -> x.itemname end) |> Enum.uniq()

          total_order = all |> Enum.count()

          total_qty = all |> Enum.map(fn x -> x.qty end) |> Enum.sum()

          total_sales = all |> Enum.map(fn x -> Decimal.to_float(x.total) end) |> Enum.sum()

          alld =
            for item <- item_name_list do
              data = all |> Enum.filter(fn x -> x.itemname == item end)

              total = data |> Enum.count()

              qty = data |> Enum.map(fn x -> x.qty end) |> Enum.sum()

              sales = data |> Enum.map(fn x -> Decimal.to_float(x.total) end) |> Enum.sum()

              order_rate = total / total_order * 100

              sales_qty = qty / total_qty * 100

              sales_revenue = sales / total_sales * 100

              %{
                a: item,
                b: order_rate |> Float.round(1),
                d: sales_qty |> Float.round(1),
                f: sales_revenue |> Float.round(1),
                c: qty,
                e: sales |> Float.round(1)
              }
            end

        "customer_analysis" ->
          all =
            Repo.all(
              from(
                s in Webpos.Reports.Sale,
                where: s.salesdate >= ^start_date and s.salesdate <= ^end_date,
                select: %{
                  date: s.salesdate,
                  pax: s.pax,
                  transaction_type: s.transaction_type
                }
              )
            )

        "discount_analysis" ->
          all =
            Repo.all(
              from(
                s in Webpos.Reports.Sale,
                where:
                  s.salesdate >= ^start_date and s.salesdate <= ^end_date and
                    s.discount_name != "n/a",
                group_by: [s.salesdate, s.discount_name, s.discount_description],
                select: %{
                  date: s.salesdate,
                  discount_name: s.discount_name,
                  discount_description: s.discount_description,
                  total_discount: sum(s.discounted_amount)
                }
              )
            )

          all =
            for item <- all do
              total_price =
                all |> Enum.map(fn x -> Decimal.to_float(x.total_discount) end) |> Enum.sum()

              item_price = item.total_discount |> Decimal.to_float()

              percentage = item_price / total_price * 100

              %{
                a: item.date |> Date.to_string(),
                b: item.discount_name,
                c: item.discount_description,
                d: item_price,
                e: percentage |> Float.round(1)
              }
            end

        "item_sales" ->
          all =
            Repo.all(
              from(
                s in Webpos.Reports.Sale,
                left_join: r in Webpos.Reports.SalesDetail,
                on: s.salesid == r.salesid,
                where: s.salesdate >= ^start_date and s.salesdate <= ^end_date,
                select: %{
                  itemname: r.itemname,
                  qty: r.qty,
                  total: r.sub_total
                }
              )
            )

          item_name_list = all |> Enum.map(fn x -> x.itemname end) |> Enum.uniq()

          total_order = all |> Enum.count()

          total_qty = all |> Enum.map(fn x -> x.qty end) |> Enum.sum()

          total_sales = all |> Enum.map(fn x -> Decimal.to_float(x.total) end) |> Enum.sum()

          alld =
            for item <- item_name_list do
              data = all |> Enum.filter(fn x -> x.itemname == item end)

              total = data |> Enum.count()

              qty = data |> Enum.map(fn x -> x.qty end) |> Enum.sum()

              sales = data |> Enum.map(fn x -> Decimal.to_float(x.total) end) |> Enum.sum()

              order_rate = total / total_order * 100

              sales_qty = qty / total_qty * 100

              sales_revenue = sales / total_sales * 100

              %{
                a: item,
                b: order_rate |> Float.round(1),
                d: sales_qty |> Float.round(1),
                f: sales_revenue |> Float.round(1),
                c: qty,
                e: sales |> Float.round(1)
              }
            end
      end
  end

  def tree_get(conn, params) do
    IO.inspect(params)

    start_date = params["start_date"]
    end_date = params["end_date"]

    case params["scope"] do
      "show_html" ->
        json_map =
          case params["data"] do
            "main_dashboard" ->
              data = data_info(start_date, end_date, "main")

              html =
                Phoenix.View.render_to_string(
                  WebposWeb.PageView,
                  "main_dashboard.html",
                  info: data,
                  conn: conn
                )

              json_map = Poison.encode!(html)

            "sales_overview" ->
              data = data_info(start_date, end_date, "sales_overview")

              total_data =
                if data != [] do
                  total_sales_revenue =
                    data |> Enum.map(fn x -> x.b end) |> Enum.sum() |> Float.round(2)

                  total_number_of_customer = data |> Enum.map(fn x -> x.d end) |> Enum.sum()

                  total_sales_per_cust =
                    data |> Enum.map(fn x -> x.e end) |> Enum.sum() |> Float.round(2)

                  total_dis_amount =
                    data |> Enum.map(fn x -> x.c end) |> Enum.sum() |> Float.round(2)

                  %{
                    total_sales_revenue: total_sales_revenue,
                    total_number_of_customer: total_number_of_customer,
                    total_sales_per_cust: total_sales_per_cust,
                    total_dis_amount: total_dis_amount
                  }
                end

              sales_revenue =
                for item <- data do
                  [item.a, item.b]
                end

              no_cust =
                for item <- data do
                  [item.a, item.d]
                end

              sales_per_cust =
                for item <- data do
                  [item.a, item.e]
                end

              dis_amount =
                for item <- data do
                  [item.a, item.c]
                end

              csv_content = [
                "Date",
                "Sales Revenue",
                "Discount Amount",
                "Number of Customer",
                "Sales per Customer",
                "Table Turnover Rate"
              ]

              header = header(csv_content)

              dd = data(data)

              final = header ++ dd

              sheet = Sheet.with_name("ItemSalesAnalysis")

              total = Enum.reduce(final, sheet, fn x, sheet -> sheet_cell_insert(sheet, x) end)

              total =
                total
                |> Sheet.set_col_width("A", 30.0)
                |> Sheet.set_col_width("B", 30.0)
                |> Sheet.set_col_width("C", 30.0)
                |> Sheet.set_col_width("D", 30.0)
                |> Sheet.set_col_width("E", 30.0)
                |> Sheet.set_col_width("F", 30.0)

              page = %Workbook{sheets: [total]}

              image_path = Application.app_dir(:webpos, "priv/static/images")

              content = page |> Elixlsx.write_to(image_path <> "/ItemSalesOverview.xlsx")

              html =
                Phoenix.View.render_to_string(
                  WebposWeb.PageView,
                  "sales_overview.html",
                  info: data,
                  total_data: total_data,
                  conn: conn
                )

              json_map =
                Poison.encode!(%{
                  html: html,
                  data: sales_revenue,
                  data2: no_cust,
                  data3: sales_per_cust,
                  data4: dis_amount
                })

            "sales_ranking" ->
              data = data_info(start_date, end_date, "sales_ranking")

              csv_content = [
                "Item Name",
                "Order Rate",
                "Sales Qty",
                "Sales Qty Percentage (%)",
                "Sales Revenue",
                "Sales Percentage (%)"
              ]

              header = header(csv_content)

              dd = data(data)

              final = header ++ dd

              sheet = Sheet.with_name("ItemSalesAnalysis")

              total = Enum.reduce(final, sheet, fn x, sheet -> sheet_cell_insert(sheet, x) end)

              total =
                total
                |> Sheet.set_col_width("A", 30.0)
                |> Sheet.set_col_width("B", 30.0)
                |> Sheet.set_col_width("C", 30.0)
                |> Sheet.set_col_width("D", 30.0)
                |> Sheet.set_col_width("E", 30.0)
                |> Sheet.set_col_width("F", 30.0)

              page = %Workbook{sheets: [total]}

              image_path = Application.app_dir(:webpos, "priv/static/images")

              content = page |> Elixlsx.write_to(image_path <> "/ItemSalesAnalysis.xlsx")

              chart_date =
                for item <- data do
                  %{
                    x: item.b,
                    y: item.f,
                    z: item.e,
                    name: '',
                    country: item.a
                  }
                end

              html =
                Phoenix.View.render_to_string(WebposWeb.PageView, "sales_ranking.html",
                  info: data,
                  conn: conn
                )

              sales_info = sales_info(start_date, end_date)

              json_map =
                Poison.encode!(%{
                  html: html,
                  data: chart_date
                })

            "customer_analysis" ->
              data = data_info(start_date, end_date, "customer_analysis")

              pie = data |> Enum.group_by(fn x -> x.transaction_type end)

              tt = pie |> Enum.map(fn x -> x |> elem(0) end) |> Enum.count()

              color = ColorStream.hex() |> Enum.take(tt)

              chart_date =
                for item <- pie |> Enum.with_index() do
                  number = item |> elem(1)
                  name = item |> elem(0) |> elem(0)

                  dine_in =
                    item |> elem(0) |> elem(1) |> Enum.map(fn x -> x.pax end) |> Enum.sum()

                  color = color |> Enum.fetch!(number)
                  color = "#" <> color

                  %{
                    label: name,
                    color: color,
                    data: dine_in
                  }
                end

              html =
                Phoenix.View.render_to_string(WebposWeb.PageView, "customer_analysis.html",
                  info: data,
                  conn: conn
                )

              json_map =
                Poison.encode!(%{
                  html: html,
                  data: chart_date
                })

            "item_sales" ->
              data = data_info(start_date, end_date, "item_sales")

              csv_content = [
                "Item Name",
                "Order Rate",
                "Sales Qty",
                "Sales Qty Percentage (%)",
                "Sales Revenue",
                "Sales Percentage (%)"
              ]

              header = header(csv_content)

              dd = data(data)

              final = header ++ dd

              sheet = Sheet.with_name("ItemSalesAnalysis")

              total = Enum.reduce(final, sheet, fn x, sheet -> sheet_cell_insert(sheet, x) end)

              total =
                total
                |> Sheet.set_col_width("A", 30.0)
                |> Sheet.set_col_width("B", 30.0)
                |> Sheet.set_col_width("C", 30.0)
                |> Sheet.set_col_width("D", 30.0)
                |> Sheet.set_col_width("E", 30.0)
                |> Sheet.set_col_width("F", 30.0)

              page = %Workbook{sheets: [total]}

              image_path = Application.app_dir(:webpos, "priv/static/images")

              content = page |> Elixlsx.write_to(image_path <> "/ItemSalesAnalysis.xlsx")

              chart_date =
                for item <- data do
                  %{
                    x: item.b,
                    y: item.f,
                    z: item.e,
                    name: '',
                    country: item.a
                  }
                end

              html =
                Phoenix.View.render_to_string(WebposWeb.PageView, "item_sales.html",
                  info: data,
                  conn: conn
                )

              sales_info = sales_info(start_date, end_date)

              json_map =
                Poison.encode!(%{
                  html: html,
                  data: chart_date,
                  data2: sales_info.a,
                  data3: sales_info.b,
                  data4: sales_info.c
                })

            "modifier_analysis" ->
              data = data_info(start_date, end_date, "service_charge")

              html =
                Phoenix.View.render_to_string(
                  WebposWeb.PageView,
                  "main_dashboard.html",
                  info: data,
                  conn: conn
                )

              json_map = Poison.encode!(html)

            "discount_analysis" ->
              data = data_info(start_date, end_date, "discount_analysis")

              csv_content = [
                "Date",
                "Discount Name",
                "Discount Description",
                "Discount Amount",
                "Discount Percentage"
              ]

              header = header(csv_content)

              dd = data(data)

              final = header ++ dd

              sheet = Sheet.with_name("DiscountAnalysis")

              total = Enum.reduce(final, sheet, fn x, sheet -> sheet_cell_insert(sheet, x) end)

              total =
                total
                |> Sheet.set_col_width("A", 30.0)
                |> Sheet.set_col_width("B", 30.0)
                |> Sheet.set_col_width("C", 30.0)
                |> Sheet.set_col_width("D", 30.0)
                |> Sheet.set_col_width("E", 30.0)

              page = %Workbook{sheets: [total]}

              image_path = Application.app_dir(:webpos, "priv/static/images")

              content = page |> Elixlsx.write_to(image_path <> "/DiscountAnalysis.xlsx")

              html =
                Phoenix.View.render_to_string(
                  WebposWeb.PageView,
                  "discount_analysis.html",
                  info: data,
                  conn: conn
                )

              group_date = data |> Enum.group_by(fn x -> x.a end)

              group_name = data |> Enum.group_by(fn x -> x.b end)

              chart_date =
                for item <- group_date do
                  date = item |> elem(0)

                  total = item |> elem(1) |> Enum.map(fn x -> x.d end) |> Enum.sum()

                  [date, total]
                end

              total = group_name |> Enum.count()

              color = ColorStream.hex() |> Enum.take(total)

              pie_chart =
                for item <- group_name |> Enum.with_index() do
                  number = item |> elem(1)

                  item = item |> elem(0)
                  date = item |> elem(0)

                  total = item |> elem(1) |> Enum.map(fn x -> x.e end) |> Enum.sum()

                  color = color |> Enum.fetch!(number)
                  color = "#" <> color

                  %{
                    label: date,
                    color: color,
                    data: total
                  }
                end

              json_map = Poison.encode!(%{html: html, data: chart_date, data2: pie_chart})

            "service_charge" ->
              data = data_info(start_date, end_date, "service_charge")

              csv_content = [
                "Date",
                "Total (RM)"
              ]

              header = header(csv_content)

              dd = data(data)

              final = header ++ dd

              sheet = Sheet.with_name("ServiceCharge")

              total = Enum.reduce(final, sheet, fn x, sheet -> sheet_cell_insert(sheet, x) end)

              total =
                total
                |> Sheet.set_col_width("A", 30.0)
                |> Sheet.set_col_width("B", 30.0)

              page = %Workbook{sheets: [total]}

              image_path = Application.app_dir(:webpos, "priv/static/images")

              content = page |> Elixlsx.write_to(image_path <> "/ServiceCharge.xlsx")

              total = data |> Enum.map(fn x -> x.total_rm end) |> Enum.sum()

              html =
                Phoenix.View.render_to_string(
                  WebposWeb.PageView,
                  "service_charge.html",
                  info: data,
                  conn: conn,
                  total: total
                )

              json_map = Poison.encode!(html)

            _ ->
              [type, id] = params["data"] |> String.split("_")

              case type do
                "j" ->
                  true

                  IEx.pry()
                  job = Repo.get(Job, id)

                  activities =
                    Logistic.list_activities(job.id)
                    |> Enum.map(fn x ->
                      Map.put(x, :img_url, TransporterWeb.JobController.map_image(x.id))
                    end)
                    |> Enum.map(fn x ->
                      Map.put(x, :date, TransporterWeb.JobController.format_date(x.inserted_at))
                    end)
                    |> Enum.group_by(fn x -> x.date end)

                  containers = Repo.all(from(c in Container, where: c.job_id == ^job.id))

                  html =
                    Phoenix.View.render_to_string(
                      TransporterWeb.JobView,
                      "show.html",
                      containers: containers,
                      job: job,
                      activities: activities,
                      conn: conn
                    )

                  json_map = Poison.encode!(html)
              end
          end

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, json_map)

      "jobs" ->
        res = [
          %{id: "main_dashboard", parent: "#", text: "Main Dashboard"},
          %{id: "sales_analysis", parent: "#", text: "Sales Analysis"},
          %{id: "sales_overview", parent: "sales_analysis", text: "Sales Overview"},
          %{id: "sales_ranking", parent: "sales_analysis", text: "Sales Ranking"},
          %{id: "customer_analysis", parent: "sales_analysis", text: "Customer Analysis"},
          %{id: "discount_overview", parent: "sales_analysis", text: "Discount Overview"},
          %{id: "time_efficiency", parent: "sales_analysis", text: "Time Efficiency"},
          %{
            id: "revenue_breakdown",
            parent: "sales_analysis",
            text: "Revenue Breakdown & Varience Report"
          },
          %{id: "item_sales", parent: "#", text: "Item Sales"},
          %{id: "modifier_analysis", parent: "#", text: "Modifier Analysis"},
          %{id: "discount_analysis", parent: "#", text: "Discount Analysis"},
          %{id: "service_charge", parent: "#", text: "Service Charge"}
        ]

        json_map = Poison.encode!(res)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, json_map)

      "show_job" ->
        job = Logistic.get_job!(params["job_id"])

        activities =
          Logistic.list_activities(job.id)
          |> Enum.map(fn x ->
            Map.put(x, :img_url, TransporterWeb.JobController.map_image(x.id))
          end)
          |> Enum.map(fn x ->
            Map.put(x, :date, TransporterWeb.JobController.format_date(x.inserted_at))
          end)
          |> Enum.group_by(fn x -> x.date end)

        html =
          Phoenix.View.render_to_string(
            TransporterWeb.JobView,
            "show.html",
            job: job,
            activities: activities,
            conn: conn
          )

        json_map = Poison.encode!(html)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, json_map)

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(%{status: "received"}))
    end
  end

  def header(csv_content) do
    for item <- csv_content |> Enum.with_index() do
      no = item |> elem(1)
      start_no = (no + 1) |> Integer.to_string()

      letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("", trim: true)

      alphabert = letters |> Enum.fetch!(no)

      start = alphabert <> "1"

      item = item |> elem(0)

      {start, item}
    end
  end

  def data(data) do
    for item <- data |> Enum.with_index() do
      no = item |> elem(1)
      start_no = (no + 2) |> Integer.to_string()
      item = item |> elem(0)

      a =
        for each <- item |> Enum.with_index() do
          letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("", trim: true)
          no = each |> elem(1)

          item = each |> elem(0) |> elem(1)

          alphabert = letters |> Enum.fetch!(no)

          start = alphabert <> start_no

          {start, item}
        end

      a
    end
    |> List.flatten()
  end

  def tree_post(conn, params) do
    IO.inspect(params)

    result =
      case params["scope"] do
        "updateforwarderContainer" ->
          job = Repo.get_by(Job, job_no: params["jobNo"])
          user = Repo.get_by(User, username: params["username"])
          ori = Repo.all(from(c in Container, where: c.job_id == ^job.id, select: c.name))
          list = Poison.decode!(params["list"]) |> Enum.reject(fn x -> x == "" end)

          for name <- list do
            container = Repo.get_by(Container, name: name)
            Logistic.update_container(container, %{status: "Pending Checking"})

            Logistic.create_activity(
              %{
                job_id: job.id,
                created_by: user.username,
                created_id: user.id,
                message: "#{user.username} has passed container #{container.name}.",
                container_id: container.id,
                container_name: container.name,
                activity_type: "forwarder_report"
              },
              job,
              user
            )
          end

          remainder = ori -- list

          for name <- remainder do
            container = Repo.get_by(Container, name: name)
            Logistic.update_container(container, %{status: "Pending Scanning"})

            Logistic.create_activity(
              %{
                job_id: job.id,
                created_by: user.username,
                created_id: user.id,
                message: "#{user.username} has update container #{container.name} to scanning.",
                container_id: container.id,
                container_name: container.name,
                activity_type: "forwarder_report"
              },
              job,
              user
            )
          end

          "ok"

        "forwarderContainer" ->
          true
          # when forwarder update it will turn into Pending Checking.
          job = Repo.get_by(Job, job_no: params["jobNo"])

          res = Repo.all(from(c in Container, where: c.job_id == ^job.id, select: c.status))

          result =
            cond do
              Enum.filter(res, fn x -> x == "Pending Scanning" end) |> Enum.count() ==
                  Enum.count(res) ->
                "P"

              Enum.filter(res, fn x -> x == "Pending Checking" end) |> Enum.count() > 0 ->
                if Enum.filter(res, fn x -> x == "Pending Checking" end) |> Enum.count() ==
                     Enum.count(res) do
                  "S"
                else
                  "Partial"
                end

              true ->
                "S"
            end

          result

        "reportJob" ->
          user = Repo.get_by(User, username: params["username"])
          # important: the job no received is actually the container no

          container =
            if params["job_type"] == "gateman" do
              %{job_no: params["job_no"], id: 0, name: ""}
            else
              Repo.all(from(c in Container, where: c.name == ^params["job_no"])) |> List.first()
            end

          job = Repo.get_by(Job, job_no: container.job_no)

          {:ok, act} =
            case params["job_type"] do
              "mover" ->
                {:ok, act} =
                  Logistic.create_activity(
                    %{
                      job_id: job.id,
                      created_by: user.username,
                      created_id: user.id,
                      message: "#{user.username} has checked container #{container.name}.",
                      location: Poison.encode!(params["position"]),
                      container_id: container.id,
                      container_name: container.name,
                      activity_type: "gateman_clear"
                    },
                    job,
                    user
                  )

                us = Repo.get_by(Logistic.UserJob, job_id: job.id, user_id: user.id)

                names =
                  job.containers |> String.split(",") |> Enum.map(fn x -> String.trim(x) end)

                containers = Repo.all(from(c in Container, where: c.name in ^names))

                res2 =
                  Logistic.update_container(container, %{
                    status: "Pending Transport",
                    return_depot: params["return_depot"]
                  })

                TransporterWeb.JobController.inform_drivers(conn, job.id, container.route_id)

                containers = Repo.all(from(c in Container, where: c.name in ^names))
                rem = Enum.filter(containers, fn x -> x.status == "Pending Checking" end)

                if Enum.count(rem) == 0 do
                  res = Logistic.update_user_job(us, %{status: "done"})
                end

                # assign to drivers

                {:ok, act}

              "gateman" ->
                {:ok, act} =
                  Logistic.create_activity(
                    %{
                      job_id: job.id,
                      created_by: user.username,
                      created_id: user.id,
                      message: "#{user.username} has cleared custom for #{job.job_no}.",
                      location: Poison.encode!(params["position"]),
                      container_id: container.id,
                      container_name: container.name,
                      activity_type: "forwarder_clear"
                    },
                    job,
                    user
                  )

                us = Repo.get_by(Logistic.UserJob, job_id: job.id, user_id: user.id)
                # when all become pending checking then only update...
                names =
                  job.containers |> String.split(",") |> Enum.map(fn x -> String.trim(x) end)

                containers = Repo.all(from(c in Container, where: c.name in ^names))

                res10 =
                  for container2 <- containers do
                    res2 = Logistic.update_container(container2, %{status: "Pending Scanning"})
                  end

                containers3 = Repo.all(from(c in Container, where: c.name in ^names))
                rem = Enum.filter(containers3, fn x -> x.status == "Pending Clearance" end)

                if Enum.count(rem) == 0 do
                  res = Logistic.update_user_job(us, %{status: "done"})

                  users2 = Repo.all(from(u in User, where: u.user_level == ^"Gateman"))
                  now = Timex.now() |> DateTime.to_unix(:millisecond)

                  for user2 <- users2 do
                    jobq = %{"job_id" => job.id, "user_id" => user2.id}
                    us = Repo.get_by(Logistic.UserJob, job_id: job.id, user_id: user2.id)

                    if us == nil do
                      jobq = Map.put(jobq, "status", "pending accept")
                      {:ok, usj} = Logistic.create_user_job(jobq)

                      Transporter.inform(user2.username, "You got a new task.")

                      {:ok, act2} =
                        Logistic.create_activity(
                          %{
                            created_by: user.username,
                            created_id: user.id,
                            job_id: usj.job_id,
                            message:
                              "Assigned to #{user2.username}. Pending accept from #{
                                user2.user_level
                              }.",
                            activity_type: "gateman_assigned"
                          },
                          job,
                          user
                        )

                      topic = "location:#{user2.username}"
                      event = "new_request"

                      message = %{
                        job_no: job.job_no,
                        description: job.description,
                        insertedAt: now,
                        pendingContainers: job.containers,
                        completedContainers: "",
                        by: act2.created_by
                      }

                      TransporterWeb.Endpoint.broadcast(topic, event, message)
                    end
                  end
                else
                  IO.print("error...")
                end

                # broadcast to all the gateman... 

                {:ok, act}

              "arrive" ->
                route = Repo.get(ContainerRoute, params["route_id"])

                type =
                  if route != nil do
                    loc = Repo.get_by(DeliveryLocation, name: route.to)

                    if loc.zone == "Home" do
                      "in_lorrydriver_end"
                    else
                      "out_lorrydriver_end"
                    end
                  else
                    "error no route found..."
                  end

                vehicles = Repo.all(from(v in Vehicle, where: v.user_id == ^user.id))

                vehicle_name =
                  if vehicles != [] do
                    List.first(vehicles).name
                  else
                    "Unknown"
                  end

                {:ok, act} =
                  Logistic.create_activity(
                    %{
                      job_id: job.id,
                      created_by: user.username,
                      created_id: user.id,
                      message:
                        "#{user.username} with container #{container.name} arrived destination.",
                      location: Poison.encode!(params["position"]),
                      container_id: container.id,
                      container_name: container.name,
                      trailer_no: params["trailer"],
                      activity_type: type,
                      truck_no: vehicle_name
                    },
                    job,
                    user
                  )

                res2 = Logistic.update_container(container, %{status: "Arrived Destination"})

                res3 =
                  Logistic.update_container_route(route, %{
                    completed_datetime: Timex.now()
                  })

                usj =
                  Repo.get_by(
                    UserJob,
                    user_id: user.id,
                    job_id: job.id,
                    route_id: params["route_id"]
                  )

                Logistic.update_user_job(usj, %{status: "done"})
                {:ok, act}

              "trailer" ->
                message =
                  "#{user.username} has pickup container #{container.name} for #{job.job_no}"

                route = Repo.get(ContainerRoute, params["route_id"])

                type =
                  if route != nil do
                    loc = Repo.get_by(DeliveryLocation, name: route.to)

                    if loc.zone == "Home" do
                      "in_lorrydriver_start"
                    else
                      "out_lorrydriver_start"
                    end
                  else
                    "error no route found..."
                  end

                vehicles = Repo.all(from(v in Vehicle, where: v.user_id == ^user.id))

                vehicle_name =
                  if vehicles != [] do
                    List.first(vehicles).name
                  else
                    "Unknown"
                  end

                {:ok, act} =
                  Logistic.create_activity(
                    %{
                      job_id: job.id,
                      created_by: user.username,
                      created_id: user.id,
                      message: message,
                      location: Poison.encode!(params["position"]),
                      container_id: container.id,
                      container_name: container.name,
                      trailer_no: params["trailer"],
                      activity_type: type,
                      truck_no: vehicle_name
                    },
                    job,
                    user
                  )

                res2 =
                  Logistic.update_container(container, %{
                    status: "Pickup Container",
                    trailer_no: params["trailer_no"]
                  })

                {:ok, act}
            end

          if params["photos"] != nil do
            map = Logistic.image_upload(params["photos"], act.id)

            a =
              Logistic.create_image(%{
                activity_id: act.id,
                filename: map.filename,
                thumbnail: map.bin
              })
          end

          "ok"

        "acceptJob" ->
          user = Repo.get_by(User, username: params["username"])

          job =
            if user.user_level == "LorryDriver" do
              Repo.get_by(Job, job_no: String.split(params["job_no"], "_") |> hd())
            else
              Repo.get_by(Job, job_no: params["job_no"])
            end

          message =
            if user.user_level == "LorryDriver" do
              "Accepted by #{user.username}. Pending pickup container from #{user.user_level}."
            else
              "#{user.username} accepted job #{job.job_no}."
            end

          message2 =
            if user.user_level == "LorryDriver" do
              "out_lorrydriver_ack"
            else
              "#{String.downcase(user.user_level)}_ack"
            end

          {:ok, act} =
            Logistic.create_activity(
              %{
                job_id: job.id,
                created_by: user.username,
                created_id: user.id,
                message: message,
                activity_type: message2
              },
              job,
              user
            )

          route =
            if user.user_level == "LorryDriver" do
              Repo.get_by(ContainerRoute, id: String.split(params["job_no"], "_") |> List.last())
            else
              nil
            end

          if route != nil do
            Logistic.update_container_route(route, %{driver_id: user.id, driver: user.username})

            res =
              Repo.all(
                from(
                  u in UserJob,
                  where:
                    u.job_id == ^job.id and u.route_id == ^route.id and
                      u.status == ^"pending accept"
                )
              )

            usj = res |> Enum.filter(fn x -> x.user_id == user.id end)

            if usj != [] do
              Logistic.update_user_job(hd(usj), %{status: "pending report", route_id: route.id})
            end

            # delete all other user jobs on the route and container... 
            res
            |> Enum.reject(fn x -> x.user_id == user.id end)
            |> Enum.map(fn x -> Repo.delete(x) end)
          else
            res =
              Repo.all(from(u in UserJob, where: u.user_id == ^user.id and u.job_id == ^job.id))

            usj = List.first(res)
            Logistic.update_user_job(usj, %{status: "pending report"})
          end

          "ok"

          # if some one cant finish the job... we dont have a handling for this situation yet.
          # its expected the users finish the job when they acknowledge it.
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{status: "received", result: result}))
  end

  def service_charge_excel(conn, params) do
    image_path = Application.app_dir(:webpos, "priv/static/images")

    file = File.read!(image_path <> "/ServiceCharge.xlsx")

    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"ServiceCharge.xlsx\""
    )
    |> send_resp(200, file)
  end

  def discount_analysis_excel(conn, params) do
    image_path = Application.app_dir(:webpos, "priv/static/images")

    file = File.read!(image_path <> "/DiscountAnalysis.xlsx")

    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"DiscountAnalysis.xlsx\""
    )
    |> send_resp(200, file)
  end

  def item_sales_analysis_excel(conn, params) do
    image_path = Application.app_dir(:webpos, "priv/static/images")

    file = File.read!(image_path <> "/ItemSalesAnalysis.xlsx")

    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"ItemSalesAnalysis.xlsx\""
    )
    |> send_resp(200, file)
  end

  def item_sales_overview_excel(conn, params) do
    image_path = Application.app_dir(:webpos, "priv/static/images")

    file = File.read!(image_path <> "/ItemSalesOverview.xlsx")

    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"ItemSalesOverview.xlsx\""
    )
    |> send_resp(200, file)
  end
end
