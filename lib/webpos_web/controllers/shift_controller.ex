defmodule WebposWeb.ShiftController do
  use WebposWeb, :controller

  alias Webpos.Reports
  alias Webpos.Reports.Shift

  def index(conn, _params) do
    shifts = Reports.list_shifts()
    render(conn, "index.html", shifts: shifts)
  end

  def new(conn, _params) do
    changeset = Reports.change_shift(%Shift{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"shift" => shift_params}) do
    case Reports.create_shift(shift_params) do
      {:ok, shift} ->
        conn
        |> put_flash(:info, "Shift created successfully.")
        |> redirect(to: shift_path(conn, :show, shift))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    shift = Reports.get_shift!(id)
    render(conn, "show.html", shift: shift)
  end

  def edit(conn, %{"id" => id}) do
    shift = Reports.get_shift!(id)
    changeset = Reports.change_shift(shift)
    render(conn, "edit.html", shift: shift, changeset: changeset)
  end

  def update(conn, %{"id" => id, "shift" => shift_params}) do
    shift = Reports.get_shift!(id)

    case Reports.update_shift(shift, shift_params) do
      {:ok, shift} ->
        conn
        |> put_flash(:info, "Shift updated successfully.")
        |> redirect(to: shift_path(conn, :show, shift))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", shift: shift, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    shift = Reports.get_shift!(id)
    {:ok, _shift} = Reports.delete_shift(shift)

    conn
    |> put_flash(:info, "Shift deleted successfully.")
    |> redirect(to: shift_path(conn, :index))
  end
end
