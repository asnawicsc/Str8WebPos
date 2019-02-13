defmodule WebposWeb.SaleController do
  use WebposWeb, :controller

  alias Webpos.Reports
  alias Webpos.Reports.Sale

  def index(conn, _params) do
    sales = Reports.list_sales()
    render(conn, "index.html", sales: sales)
  end

  def new(conn, _params) do
    changeset = Reports.change_sale(%Sale{})
    render(conn, "new.html", changeset: changeset)
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
