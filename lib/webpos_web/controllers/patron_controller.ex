defmodule WebposWeb.PatronController do
  use WebposWeb, :controller

  alias Webpos.Settings
  alias Webpos.Settings.Patron

  def index(conn, _params) do
    patrons = Settings.list_patrons()
    render(conn, "index.html", patrons: patrons)
  end

  def new(conn, _params) do
    changeset = Settings.change_patron(%Patron{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"patron" => patron_params}) do
    case Settings.create_patron(patron_params) do
      {:ok, patron} ->
        conn
        |> put_flash(:info, "Patron created successfully.")
        |> redirect(to: patron_path(conn, :show, patron))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    patron = Settings.get_patron!(id)
    render(conn, "show.html", patron: patron)
  end

  def edit(conn, %{"id" => id}) do
    patron = Settings.get_patron!(id)
    changeset = Settings.change_patron(patron)
    render(conn, "edit.html", patron: patron, changeset: changeset)
  end

  def update(conn, %{"id" => id, "patron" => patron_params}) do
    patron = Settings.get_patron!(id)

    case Settings.update_patron(patron, patron_params) do
      {:ok, patron} ->
        conn
        |> put_flash(:info, "Patron updated successfully.")
        |> redirect(to: patron_path(conn, :show, patron))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", patron: patron, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    patron = Settings.get_patron!(id)
    {:ok, _patron} = Settings.delete_patron(patron)

    conn
    |> put_flash(:info, "Patron deleted successfully.")
    |> redirect(to: patron_path(conn, :index))
  end
end
