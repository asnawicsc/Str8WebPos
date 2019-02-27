defmodule WebposWeb.ItemController do
  use WebposWeb, :controller

  alias Webpos.Menu
  alias Webpos.Menu.Item
  alias Webpos.Reports.ModalLllog
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

    if item_params["img"] != nil do
      img_url = Settings.image_upload(item_params["img"], Settings.get_org_id(conn))
      item_params = Map.put(item_params, "img_url", img_url)
    end

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
    item_params = Map.put(item_params, "organization_id", Settings.get_org_id(conn))

    if item_params["img"] != nil do
      img_url = Settings.image_upload(item_params["img"], Settings.get_org_id(conn))
      item_params = Map.put(item_params, "img_url", img_url)
    end

    log_before =
      item |> Map.from_struct() |> Map.drop([:__meta__, :__struct__]) |> Poison.encode!()

    case Menu.update_item(item, item_params) do
      {:ok, item} ->
        log_after =
          item |> Map.from_struct() |> Map.drop([:__meta__, :__struct__]) |> Poison.encode!()

        Settings.modal_log_create(conn, log_before, log_after, item)

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

  def modal_log(user_name, user_type, org_id) do
  end
end
