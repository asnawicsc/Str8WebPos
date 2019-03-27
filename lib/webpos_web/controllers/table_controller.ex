defmodule WebposWeb.TableController do
  use WebposWeb, :controller

  alias Webpos.Settings
  alias Webpos.Settings.Table

  def index(conn, _params) do
    tables = Settings.list_tables()
    render(conn, "index.html", tables: tables)
  end

  def new(conn, _params) do
    changeset = Settings.change_table(%Table{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"table" => table_params}) do
    case Settings.create_table(table_params) do
      {:ok, table} ->
        conn
        |> put_flash(:info, "Table created successfully.")
        |> redirect(to: table_path(conn, :show, table))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    table = Settings.get_table!(id)
    render(conn, "show.html", table: table)
  end

  def edit(conn, %{"id" => id}) do
    table = Settings.get_table!(id)
    changeset = Settings.change_table(table)
    render(conn, "edit.html", table: table, changeset: changeset)
  end

  def update(conn, %{"id" => id, "table" => table_params}) do
    table = Settings.get_table!(id)

    case Settings.update_table(table, table_params) do
      {:ok, table} ->
        conn
        |> put_flash(:info, "Table updated successfully.")
        |> redirect(to: table_path(conn, :show, table))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", table: table, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    table = Settings.get_table!(id)
    {:ok, _table} = Settings.delete_table(table)

    conn
    |> put_flash(:info, "Table deleted successfully.")
    |> redirect(to: table_path(conn, :index))
  end
end
