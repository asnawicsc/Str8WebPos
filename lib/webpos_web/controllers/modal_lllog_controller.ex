defmodule WebposWeb.ModalLllogController do
  use WebposWeb, :controller

  alias Webpos.Reports
  alias Webpos.Reports.ModalLllog
  require IEx

  def index(conn, _params) do
    a = conn.private.plug_session["org_id"]

    modallogs =
      Reports.list_modallogs()
      |> Enum.filter(fn x -> x.organization_id == a end)

    render(conn, "index.html", modallogs: modallogs)
  end

  def new(conn, _params) do
    changeset = Reports.change_modal_lllog(%ModalLllog{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"modal_lllog" => modal_lllog_params}) do
    case Reports.create_modal_lllog(modal_lllog_params) do
      {:ok, modal_lllog} ->
        conn
        |> put_flash(:info, "Modal lllog created successfully.")
        |> redirect(to: modal_lllog_path(conn, :show, modal_lllog))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    modal_lllog = Reports.get_modal_lllog!(id)
    render(conn, "show.html", modal_lllog: modal_lllog)
  end

  def edit(conn, %{"id" => id}) do
    modal_lllog = Reports.get_modal_lllog!(id)
    changeset = Reports.change_modal_lllog(modal_lllog)
    render(conn, "edit.html", modal_lllog: modal_lllog, changeset: changeset)
  end

  def update(conn, %{"id" => id, "modal_lllog" => modal_lllog_params}) do
    modal_lllog = Reports.get_modal_lllog!(id)

    case Reports.update_modal_lllog(modal_lllog, modal_lllog_params) do
      {:ok, modal_lllog} ->
        conn
        |> put_flash(:info, "Modal lllog updated successfully.")
        |> redirect(to: modal_lllog_path(conn, :show, modal_lllog))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", modal_lllog: modal_lllog, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    modal_lllog = Reports.get_modal_lllog!(id)
    {:ok, _modal_lllog} = Reports.delete_modal_lllog(modal_lllog)

    conn
    |> put_flash(:info, "Modal lllog deleted successfully.")
    |> redirect(to: modal_lllog_path(conn, :index))
  end
end
