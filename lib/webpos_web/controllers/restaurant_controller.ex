defmodule WebposWeb.RestaurantController do
  use WebposWeb, :controller

  alias Webpos.Settings
  alias Webpos.Settings.Restaurant
  require IEx

  def rest_orders(rest_id, organization_id) do
    Repo.all(
      from(
        o in Order,
        where: o.rest_id == ^rest_id and o.organization_id == ^organization_id,
        select: %{
          id: o.order_id,
          items: o.items,
          salesdate: o.salesdate,
          salesdatetime: o.salesdatetime,
          table_id: o.table_id
        }
      )
    )
    |> Enum.map(fn x -> Map.put(x, :items, Poison.decode!(x.items)) end)
  end

  def get_api2(conn, %{"code" => branch_code, "license_key" => api_key}) do
    branch = Repo.all(from(b in Restaurant, where: b.code == ^branch_code))
    organization = Repo.get(Organization, hd(branch).organization_id)
    invoice = 1000

    result =
      Repo.all(
        from(
          s in Sale,
          where:
            s.organization_id == ^hd(branch).organization_id and s.rest_name == ^hd(branch).name,
          select: s.invoiceno,
          order_by: [desc: s.invoiceno],
          limit: 10
        )
      )
      |> Enum.reject(fn x -> x == nil end)

    IO.inspect(result)

    invoice =
      if result != [] do
        hd(result) + 1
      else
        1000
      end

    IO.inspect(invoice)

    if branch != [] do
      if api_key == hd(branch).key do
        branch = hd(branch)

        json = %{
          auth: "ok",
          invoice: invoice,
          tax_id: branch.tax_id,
          reg_id: branch.reg_id,
          tax_perc: branch.tax_perc,
          serv: branch.serv,
          name: branch.name,
          address: branch.address,
          payments: regex_payments(organization.payments),
          tables: restTables(branch.id),
          printers: getPrinters(branch.id),
          menu_items: WebposWeb.RestaurantChannel.map_items(branch.op_id, branch.id),
          orders: rest_orders(branch.id, branch.organization_id),
          shift: latest_unclosed_shift(branch.id)
        }

        IO.inspect(json)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(json))
      else
        json = %{auth: "not ok", invoice: invoice}
        send_resp(conn, 500, Poison.encode!(json))
      end
    else
      json = %{auth: "not ok", invoice: invoice}
      send_resp(conn, 500, Poison.encode!(json))
    end

    topic = "restaurant:#{hd(branch).code}"
    event = "query_sales_today"

    WebposWeb.Endpoint.broadcast(topic, event, %{invoice_no: invoice})
  end

  def latest_unclosed_shift(rest_id) do
    res =
      Repo.all(
        from(
          s in Shift,
          where: s.rest_id == ^rest_id and is_nil(s.close_amount),
          select: %{
            opening_staff_name: s.opening_staff,
            start_datetime: s.start_datetime,
            open_amount: s.open_amount
          }
        )
      )

    if res != [] do
      List.last(res)
    else
      nil
    end
  end

  def getPrinters(rest_id) do
    Repo.all(
      from(
        r in RestItemPrinter,
        left_join: p in Printer,
        on: p.id == r.printer_id,
        where: r.rest_id == ^rest_id and is_nil(r.item_id),
        select: %{
          name: p.name,
          ip: p.ip_address,
          port: p.port_no
        }
      )
    )
  end

  def restTables(rest_id) do
    Repo.all(
      from(
        t in Table,
        where: t.rest_id == ^rest_id,
        select: %{
          id: t.rest_table_id,
          name: t.name,
          dx: t.pos_x,
          dy: t.pos_y
        }
      )
    )
    |> Enum.map(fn x -> Map.put(x, :dx, Decimal.new(x.dx)) end)
    |> Enum.map(fn x -> Map.put(x, :dy, Decimal.new(x.dy)) end)

    #  |> Enum.map(fn x -> Map.put(:dy, Decimal.new(x.dy) end))
  end

  def regex_payments(p) do
    list = p |> String.split(",")

    b =
      for l <- list do
        l

        a = Repo.all(from(p in Payment, where: p.name == ^l)) |> hd()

        %{name: a.name, description: a.description, regex: a.regex}
      end

    b
  end

  def index(conn, _params) do
    user = Settings.current_user(conn)
    restaurants = Settings.list_restaurants(user.organization_id)
    render(conn, "index.html", restaurants: restaurants)
  end

  def new(conn, _params) do
    changeset = Settings.change_restaurant(%Restaurant{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"restaurant" => restaurant_params}) do
    restaurant_params = Map.put(restaurant_params, "organization_id", Settings.get_org_id(conn))

    case Settings.create_restaurant(restaurant_params) do
      {:ok, restaurant} ->
        conn
        |> put_flash(:info, "Restaurant created successfully.")
        |> redirect(
          to: restaurant_path(conn, :show, Settings.get_org_name_encoded(conn), restaurant)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    restaurant = Settings.get_restaurant!(id)

    if Settings.get_org_name_encoded(conn) == conn.params["org_name"] do
      items = Menu.list_items(restaurant.organization_id)
      categories = Enum.map(items, fn x -> x.category end) |> Enum.uniq()

      printers =
        Repo.all(
          from(
            p in Printer,
            left_join: i in RestItemPrinter,
            on: p.id == i.printer_id,
            where: i.rest_id == ^id and is_nil(i.item_id)
          )
        )

      render(
        conn,
        "show.html",
        items: items,
        restaurant: restaurant,
        categories: categories,
        printers: printers
      )
    else
      conn
      |> put_flash(:error, "Invalid organization name")
      |> redirect(to: organization_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    restaurant = Settings.get_restaurant!(id)
    changeset = Settings.change_restaurant(restaurant)
    render(conn, "edit.html", restaurant: restaurant, changeset: changeset)
  end

  def update(conn, %{"id" => id, "restaurant" => restaurant_params}) do
    restaurant = Settings.get_restaurant!(id)
    restaurant_params = Map.put(restaurant_params, "organization_id", Settings.get_org_id(conn))

    log_before =
      restaurant |> Map.from_struct() |> Map.drop([:__meta__, :__struct__]) |> Poison.encode!()

    case Settings.update_restaurant(restaurant, restaurant_params) do
      {:ok, restaurant} ->
        log_after =
          restaurant
          |> Map.from_struct()
          |> Map.drop([:__meta__, :__struct__])
          |> Poison.encode!()

        Settings.modal_log_create(conn, log_before, log_after, restaurant)

        conn
        |> put_flash(:info, "Restaurant updated successfully.")
        |> redirect(
          to: restaurant_path(conn, :show, Settings.get_org_name_encoded(conn), restaurant)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", restaurant: restaurant, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    restaurant = Settings.get_restaurant!(id)
    {:ok, _restaurant} = Settings.delete_restaurant(restaurant)

    conn
    |> put_flash(:info, "Restaurant deleted successfully.")
    |> redirect(to: restaurant_path(conn, :index))
  end
end
