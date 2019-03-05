defmodule WebposWeb.VoidItemController do
  use WebposWeb, :controller

  alias Webpos.Reports
  alias Webpos.Reports.VoidItem

  def index(conn, _params) do
    void_items = Reports.list_void_items()
    render(conn, "index.html", void_items: void_items)
  end

  def new(conn, _params) do
    changeset = Reports.change_void_item(%VoidItem{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"void_item" => void_item_params}) do
    case Reports.create_void_item(void_item_params) do
      {:ok, void_item} ->
        conn
        |> put_flash(:info, "Void item created successfully.")
        |> redirect(to: void_item_path(conn, :show, void_item))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    void_item = Reports.get_void_item!(id)
    render(conn, "show.html", void_item: void_item)
  end

  def edit(conn, %{"id" => id}) do
    void_item = Reports.get_void_item!(id)
    changeset = Reports.change_void_item(void_item)
    render(conn, "edit.html", void_item: void_item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "void_item" => void_item_params}) do
    void_item = Reports.get_void_item!(id)

    case Reports.update_void_item(void_item, void_item_params) do
      {:ok, void_item} ->
        conn
        |> put_flash(:info, "Void item updated successfully.")
        |> redirect(to: void_item_path(conn, :show, void_item))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", void_item: void_item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    void_item = Reports.get_void_item!(id)
    {:ok, _void_item} = Reports.delete_void_item(void_item)

    conn
    |> put_flash(:info, "Void item deleted successfully.")
    |> redirect(to: void_item_path(conn, :index))
  end
end
