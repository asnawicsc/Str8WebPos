defmodule WebposWeb.RestaurantController do
  use WebposWeb, :controller

  alias Webpos.Settings
  alias Webpos.Settings.Restaurant
  require IEx

  def get_api2(conn, %{"code" => branch_code, "license_key" => api_key}) do
    IO.inspect(conn)
    branch = Repo.all(from(b in Restaurant, where: b.code == ^branch_code))
    invoice = 1000

    result =
      Repo.all(
        from(
          s in Sale,
          where: s.organization_id == ^branch.organization_id and s.rest_name == ^branch.name,
          select: s.invoiceno,
          order_by: [desc: s.invoiceno],
          limit: 10
        )
      )

    invoice =
      if result != [] do
        hd(result)
      else
        1000
      end

    if branch != [] do
      IO.inspect(api_key)
      IO.inspect(hd(branch).key)

      json = %{
        auth: "ok",
        invoice: invoice,
        tax_id: branch.tax_id,
        reg_id: branch.reg_id,
        tax_perc: branch.tax_perc,
        serv: branch.serv
      }

      if api_key == hd(branch).key do
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

    case Settings.update_restaurant(restaurant, restaurant_params) do
      {:ok, restaurant} ->
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
