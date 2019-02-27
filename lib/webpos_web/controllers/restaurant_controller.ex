defmodule WebposWeb.RestaurantController do
  use WebposWeb, :controller

  alias Webpos.Settings
  alias Webpos.Settings.Restaurant
  require IEx

  def get_api2(conn, %{"code" => branch_code, "license_key" => api_key}) do
    branch = Repo.all(from(b in Restaurant, where: b.code == ^branch_code))
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
          name: branch.name
        }

        IO.inspect(json)
        send_resp(conn, 200, Poison.encode!(json))
      else
        json = %{auth: "not ok", invoice: invoice}
        send_resp(conn, 500, Poison.encode!(json))
      end
    else
      json = %{auth: "not ok", invoice: invoice}
      send_resp(conn, 500, Poison.encode!(json))
    end
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

    user_name = conn.private.plug_session["user_name"]
    user_type = conn.private.plug_session["user_type"]
    org_id = conn.private.plug_session["org_id"]

    log_before =
      restaurant |> Map.from_struct() |> Map.drop([:__meta__, :__struct__]) |> Poison.encode!()

    case Settings.update_restaurant(restaurant, restaurant_params) do
      {:ok, restaurant} ->
        log_after =
          restaurant
          |> Map.from_struct()
          |> Map.drop([:__meta__, :__struct__])
          |> Poison.encode!()

        a = log_before |> Poison.decode!() |> Enum.map(fn x -> x end)
        b = log_after |> Poison.decode!() |> Enum.map(fn x -> x end)
        bef = a -- b
        aft = b -- a

        fullsec =
          for item <- aft |> Enum.filter(fn x -> x |> elem(0) != "updated_at" end) do
            data = item |> elem(0)
            data2 = item |> elem(1)

            bef = bef |> Enum.filter(fn x -> x |> elem(0) == data end) |> hd

            full_bef = bef |> elem(1)

            fullsec = data <> ": change " <> full_bef <> " to " <> data2
            fullsec
          end
          |> Poison.encode!()

        datetime = Timex.now() |> DateTime.to_naive()

        modal_log_params = %{
          user_name: user_name,
          user_type: user_type,
          before_change: log_before,
          after_change: log_after,
          datetime: datetime,
          category: conn.path_info |> hd,
          primary_id: restaurant.id,
          changes: fullsec,
          organization_id: org_id
        }

        Reports.create_modal_lllog(modal_log_params)

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
