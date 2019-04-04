defmodule WebposWeb.PatronPointController do
  use WebposWeb, :controller

  alias Webpos.Settings
  alias Webpos.Settings.PatronPoint

  def index(conn, _params) do
    patron_points = Settings.list_patron_points()
    render(conn, "index.html", patron_points: patron_points)
  end

  def new(conn, _params) do
    changeset = Settings.change_patron_point(%PatronPoint{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"patron_point" => patron_point_params}) do
    case Settings.create_patron_point(patron_point_params) do
      {:ok, patron_point} ->
        conn
        |> put_flash(:info, "Patron point created successfully.")
        |> redirect(to: patron_point_path(conn, :show, patron_point))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    patron_point = Settings.get_patron_point!(id)
    render(conn, "show.html", patron_point: patron_point)
  end

  def edit(conn, %{"id" => id}) do
    patron_point = Settings.get_patron_point!(id)
    changeset = Settings.change_patron_point(patron_point)
    render(conn, "edit.html", patron_point: patron_point, changeset: changeset)
  end

  def update(conn, %{"id" => id, "patron_point" => patron_point_params}) do
    patron_point = Settings.get_patron_point!(id)

    case Settings.update_patron_point(patron_point, patron_point_params) do
      {:ok, patron_point} ->
        conn
        |> put_flash(:info, "Patron point updated successfully.")
        |> redirect(to: patron_point_path(conn, :show, patron_point))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", patron_point: patron_point, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    patron_point = Settings.get_patron_point!(id)
    {:ok, _patron_point} = Settings.delete_patron_point(patron_point)

    conn
    |> put_flash(:info, "Patron point deleted successfully.")
    |> redirect(to: patron_point_path(conn, :index))
  end
end
