defmodule WebposWeb.OrganizationPriceController do
  use WebposWeb, :controller

  alias Webpos.Menu
  alias Webpos.Menu.OrganizationPrice
  require IEx

  def get_item_price(conn, params) do
    json_map =
      Repo.all(
        from(
          i in ItemPrice,
          where: i.op_id == ^params["op_id"] and i.item_id == ^params["item_id"],
          select: %{
            price: i.price
          }
        )
      )
      |> Poison.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json_map)
  end

  def update_item_price(conn, %{"op_id" => op_id, "item" => items}) do
    item_ids = Map.keys(items)

    for item_id <- item_ids do
      # find new or update
      changes = %{
        op_id: op_id,
        item_id: item_id,
        price: Decimal.new(items[item_id])
      }

      result =
        case Repo.get_by(ItemPrice, op_id: op_id, item_id: item_id) do
          nil ->
            %ItemPrice{}

          ip ->
            ip
        end
        |> ItemPrice.changeset(changes)
        |> Repo.insert_or_update()

      IO.inspect(result)
    end

    conn
    |> put_flash(:info, "Item price updated successfully.")
    |> redirect(to: restaurant_path(conn, :show, conn.params["rest_id"]))
  end

  def index(conn, _params) do
    organization_price = Menu.list_organization_price()
    render(conn, "index.html", organization_price: organization_price)
  end

  def new(conn, _params) do
    changeset = Menu.change_organization_price(%OrganizationPrice{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"organization_price" => organization_price_params}) do
    case Menu.create_organization_price(organization_price_params) do
      {:ok, organization_price} ->
        conn
        |> put_flash(:info, "Organization price created successfully.")
        |> redirect(to: organization_price_path(conn, :index, organization_price.organization_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    organization_price = Menu.get_organization_price!(id)
    render(conn, "show.html", organization_price: organization_price)
  end

  def edit(conn, %{"id" => id}) do
    organization_price = Menu.get_organization_price!(id)
    changeset = Menu.change_organization_price(organization_price)
    render(conn, "edit.html", organization_price: organization_price, changeset: changeset)
  end

  def update(conn, %{"id" => id, "organization_price" => organization_price_params}) do
    organization_price = Menu.get_organization_price!(id)

    case Menu.update_organization_price(organization_price, organization_price_params) do
      {:ok, organization_price} ->
        conn
        |> put_flash(:info, "Organization price updated successfully.")
        |> redirect(to: organization_price_path(conn, :show, organization_price))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", organization_price: organization_price, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization_price = Menu.get_organization_price!(id)
    {:ok, _organization_price} = Menu.delete_organization_price(organization_price)

    conn
    |> put_flash(:info, "Organization price deleted successfully.")
    |> redirect(to: organization_price_path(conn, :index))
  end
end
