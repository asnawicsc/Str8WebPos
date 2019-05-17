defmodule WebposWeb.SaleController do
  use WebposWeb, :controller
  require IEx
  alias Webpos.Reports
  alias Webpos.Reports.Sale

  def sync(conn, %{"code" => code, "invoice" => invoice}) do
    r = Repo.get_by(Restaurant, name: code)
    topic = "restaurant:#{r.code}"
    event = "query_sales_today"
    IO.inspect(topic)
    WebposWeb.Endpoint.broadcast(topic, event, %{invoice_no: invoice})

    conn
    |> put_flash(:info, "Sale sync requested successfully.")
    |> redirect(to: sale_path(conn, :index))
  end

  def index(conn, _params) do
    organization_id = Settings.get_org_id(conn)
    sales = Reports.list_sales(organization_id)
    render(conn, "index.html", sales: sales)
  end

  def new(conn, _params) do
    changeset = Reports.change_sale(%Sale{})
    render(conn, "new.html", changeset: changeset)
  end

  def test(conn, params) do
    # month_start = payload["date_start"] |> String.to_integer()
    # month_end = payload["date_end"] |> String.to_integer()

    list_month = 1..2

    organization = Repo.get_by(Organization, code: "resertech")

    code =
      Repo.all(
        from(
          i in Webpos.Settings.Restaurant,
          where: i.organization_id == ^organization.id,
          select: i.name
        )
      )

    IO.inspect(code)

    all = ["All Branch"]

    codes = all ++ code

    all_branch =
      Repo.all(
        from(
          i in Reports.Sale,
          where: i.organization_id == ^organization.id,
          select: %{
            salesdate: i.salesdate,
            sales: i.grand_total,
            rest_name: "All Branch"
          }
        )
      )

    sales =
      Repo.all(
        from(
          i in Reports.Sale,
          where: i.organization_id == ^organization.id,
          select: %{
            salesdate: i.salesdate,
            sales: i.grand_total,
            rest_name: i.rest_name
          }
        )
      )

    sales = all_branch ++ sales

    final =
      for code <- codes do
        sp_sales = sales |> Enum.filter(fn x -> x.rest_name == code end)

        b =
          for item <- list_month do
            sales = sp_sales |> Enum.filter(fn x -> x.salesdate.month == item end)

            total =
              if sales == [] do
                %{branch: code, month: item, sales: 0}
              else
                sales =
                  sales
                  |> Enum.filter(fn x -> x.sales != nil end)
                  |> Enum.map(fn x -> Decimal.to_float(x.sales) end)
                  |> Enum.sum()
                  |> Float.round(2)

                %{branch: code, month: item, sales: sales}
              end

            total
          end

        b
      end
      |> List.flatten()

    al =
      Repo.all(
        from(i in Reports.Sale,
          left_join: p in Reports.SalesDetail,
          on: i.salesid == p.salesid,
          where: i.organization_id == ^organization.id,
          select: %{
            item: p.itemname,
            sales: p.sub_total,
            rest_name: "All Branch",
            salesdate: i.salesdate
          }
        )
      )
      |> Enum.filter(fn x -> x.item != nil end)
      |> Enum.filter(fn x -> x.sales != nil end)

    all_month =
      for item <- list_month do
        sales = al |> Enum.filter(fn x -> x.salesdate.month == item end)

        sa = sales |> Enum.group_by(fn x -> x.item end) |> Map.keys()

        tt =
          for sp <- sa do
            each = sales |> Enum.filter(fn x -> x.item == sp end)

            sales = each |> Enum.map(fn x -> Decimal.to_float(x.sales) end) |> Enum.sum()
            rest_name = each |> Enum.map(fn x -> x.rest_name end) |> Enum.uniq() |> hd
            month = item

            %{
              item: sp,
              sales: sales |> Float.round(2),
              rest_name: rest_name,
              month: item
            }
          end
          |> Enum.sort_by(fn x -> x.sales end)
          |> Enum.reverse()

        tt
      end
      |> List.flatten()

    al2 =
      Repo.all(
        from(i in Reports.Sale,
          left_join: p in Reports.SalesDetail,
          on: i.salesid == p.salesid,
          where: i.organization_id == ^organization.id,
          select: %{
            item: p.itemname,
            sales: p.sub_total,
            rest_name: i.rest_name,
            salesdate: i.salesdate
          }
        )
      )
      |> Enum.filter(fn x -> x.item != nil end)
      |> Enum.filter(fn x -> x.sales != nil end)

    spec_month =
      for res <- code do
        rest = al2 |> Enum.filter(fn x -> x.rest_name == res end)

        rt =
          for item <- list_month do
            sales = rest |> Enum.filter(fn x -> x.salesdate.month == item end)

            sa = sales |> Enum.group_by(fn x -> x.item end) |> Map.keys()

            tt =
              for sp <- sa do
                each = sales |> Enum.filter(fn x -> x.item == sp end)

                sales = each |> Enum.map(fn x -> Decimal.to_float(x.sales) end) |> Enum.sum()
                rest_name = each |> Enum.map(fn x -> x.rest_name end) |> Enum.uniq() |> hd
                month = item

                %{
                  item: sp,
                  sales: sales |> Float.round(2),
                  rest_name: rest_name,
                  month: item
                }
              end
              |> Enum.sort_by(fn x -> x.sales end)
              |> Enum.reverse()

            tt
          end

        rt
      end
      |> List.flatten()

    rec = all_month ++ spec_month

    result3 =
      for code <- codes do
        rec_item = rec |> Enum.filter(fn x -> x.rest_name == code end)

        for item <- rec_item do
          sales = item.sales

          new_sales =
            if sales != 0.0 do
              sales
            else
              "0.0"
            end

          %{branch: code, item: item.item, sales: new_sales}
        end
      end
      |> List.flatten()
      |> Enum.filter(fn x -> x != [] end)

    all_branch_sales_payment =
      Repo.all(
        from(
          i in Reports.Sale,
          left_join: k in Reports.SalesPayment,
          on: i.salesid == k.salesid,
          where: i.organization_id == ^organization.id,
          select: %{
            payment_type: k.payment_type,
            sales: i.grand_total,
            rest_name: "All Branch",
            salesdate: i.salesdate
          }
        )
      )

    sales_payment =
      Repo.all(
        from(
          i in Reports.Sale,
          left_join: k in Reports.SalesPayment,
          on: i.salesid == k.salesid,
          where: i.organization_id == ^organization.id,
          select: %{
            payment_type: k.payment_type,
            sales: i.grand_total,
            rest_name: i.rest_name,
            salesdate: i.salesdate
          }
        )
      )

    payment_type = organization.payments |> String.split(",")

    sales_p = all_branch_sales_payment ++ sales_payment

    final_sales_payment =
      for code <- codes do
        spp_sales = sales_p |> Enum.filter(fn x -> x.rest_name == code end)

        k =
          for item <- list_month do
            sales_m = spp_sales |> Enum.filter(fn x -> x.salesdate.month == item end)

            b =
              for pt <- payment_type do
                sales_k = sales_m |> Enum.filter(fn x -> x.payment_type == pt end)

                total =
                  if sales_k == [] do
                    %{branch: code, payment_type: pt, month: item, sales: 0}
                  else
                    sales_k =
                      sales_k
                      |> Enum.filter(fn x -> x.sales != nil end)
                      |> Enum.map(fn x -> Decimal.to_float(x.sales) end)
                      |> Enum.sum()
                      |> Float.round(2)

                    %{branch: code, payment_type: pt, month: item, sales: sales_k}
                  end

                total
              end

            b
          end

        k
      end
      |> List.flatten()

    last =
      for code <- codes do
        gp = final_sales_payment |> Enum.filter(fn x -> x.branch == code end)

        for pt <- payment_type do
          sales_k = gp |> Enum.filter(fn x -> x.payment_type == pt end)

          total =
            if sales_k == [] do
              %{branch: code, payment_type: pt, sales: 0}
            else
              sales_k =
                sales_k
                |> Enum.filter(fn x -> x.sales != nil end)
                |> Enum.map(fn x -> x.sales end)
                |> Enum.sum()

              %{branch: code, payment_type: pt, sales: sales_k}
            end
        end
      end
      |> List.flatten()
  end

  def create(conn, %{"sale" => sale_params}) do
    case Reports.create_sale(sale_params) do
      {:ok, sale} ->
        conn
        |> put_flash(:info, "Sale created successfully.")
        |> redirect(to: sale_path(conn, :show, sale))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sale = Reports.get_sale!(id)
    render(conn, "show.html", sale: sale)
  end

  def edit(conn, %{"id" => id}) do
    sale = Reports.get_sale!(id)
    changeset = Reports.change_sale(sale)
    render(conn, "edit.html", sale: sale, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sale" => sale_params}) do
    sale = Reports.get_sale!(id)

    case Reports.update_sale(sale, sale_params) do
      {:ok, sale} ->
        conn
        |> put_flash(:info, "Sale updated successfully.")
        |> redirect(to: sale_path(conn, :show, sale))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", sale: sale, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sale = Reports.get_sale!(id)
    {:ok, _sale} = Reports.delete_sale(sale)

    conn
    |> put_flash(:info, "Sale deleted successfully.")
    |> redirect(to: sale_path(conn, :index))
  end
end
