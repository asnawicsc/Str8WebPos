defmodule WebposWeb.ItemController do
  use WebposWeb, :controller

  alias Webpos.Menu
  alias Webpos.Menu.Item
  require IEx

  def index(conn, params) do
    organization_id =
      if conn.params["org_name"] != nil do
        Repo.get_by(Organization, name: conn.params["org_name"] |> Base.url_decode64!()).id
      else
        nil
      end

    items = Menu.list_items(organization_id)
    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    changeset = Menu.change_item(%Item{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    item_params = Map.put(item_params, "organization_id", Settings.get_org_id(conn))

    img_url = Settings.image_upload(item_params["img"], Settings.get_org_id(conn))
    item_params = Map.put(item_params, "img_url", img_url)

    case Menu.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: item_path(conn, :show, item))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Menu.get_item!(id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Menu.get_item!(id)
    changeset = Menu.change_item(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Menu.get_item!(id)

    img_url = Settings.image_upload(item_params["img"], Settings.get_org_id(conn))
    item_params = Map.put(item_params, "img_url", img_url)

    case Menu.update_item(item, item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: item_path(conn, :show, item))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Menu.get_item!(id)
    {:ok, _item} = Menu.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: item_path(conn, :index))
  end
end
