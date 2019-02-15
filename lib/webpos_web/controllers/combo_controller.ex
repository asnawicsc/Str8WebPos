defmodule WebposWeb.ComboController do
  use WebposWeb, :controller

  alias Webpos.Menu
  alias Webpos.Menu.Combo
  require IEx

  def index(conn, params) do
    combo_id = conn.params["item_id"]
    combos = Menu.list_combos(combo_id)
    render(conn, "index.html", combos: combos)
  end

  def new(conn, _params) do
    changeset = Menu.change_combo(%Combo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"combo" => combo_params}) do
    case Menu.create_combo(combo_params) do
      {:ok, combo} ->
        conn
        |> put_flash(:info, "Combo created successfully.")
        |> redirect(to: combo_path(conn, :index, combo_params["combo_id"]))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    combo = Menu.get_combo!(id)
    render(conn, "show.html", combo: combo)
  end

  def edit(conn, %{"id" => id}) do
    combo = Menu.get_combo!(id)
    changeset = Menu.change_combo(combo)
    render(conn, "edit.html", combo: combo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "combo" => combo_params}) do
    combo = Menu.get_combo!(id)

    case Menu.update_combo(combo, combo_params) do
      {:ok, combo} ->
        conn
        |> put_flash(:info, "Combo updated successfully.")
        |> redirect(to: combo_path(conn, :show, combo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", combo: combo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    combo = Menu.get_combo!(id)
    {:ok, _combo} = Menu.delete_combo(combo)

    conn
    |> put_flash(:info, "Combo deleted successfully.")
    |> redirect(to: combo_path(conn, :index, combo.combo_id))
  end
end
