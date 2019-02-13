defmodule WebposWeb.PrinterController do
  use WebposWeb, :controller

  alias Webpos.Menu
  alias Webpos.Menu.Printer
  require IEx

  def index(conn, params) do
    organization_id = Settings.get_org_id(conn)

    printers = Menu.list_printers(organization_id)
    render(conn, "index.html", printers: printers)
  end

  def new(conn, _params) do
    changeset = Menu.change_printer(%Printer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"printer" => printer_params}) do
    printer_params = Map.put(printer_params, "organization_id", Settings.get_org_id(conn))

    case Menu.create_printer(printer_params) do
      {:ok, printer} ->
        conn
        |> put_flash(:info, "Printer created successfully.")
        |> redirect(
          to: printer_path(conn, :index, Base.url_encode64(Settings.get_org_name(conn)))
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    printer = Menu.get_printer!(id)
    render(conn, "show.html", printer: printer)
  end

  def edit(conn, %{"id" => id}) do
    printer = Menu.get_printer!(id)
    changeset = Menu.change_printer(printer)
    render(conn, "edit.html", printer: printer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "printer" => printer_params}) do
    printer_params = Map.put(printer_params, "organization_id", Settings.get_org_id(conn))
    printer = Menu.get_printer!(id)

    case Menu.update_printer(printer, printer_params) do
      {:ok, printer} ->
        conn
        |> put_flash(:info, "Printer updated successfully.")
        |> redirect(
          to: printer_path(conn, :index, Base.url_encode64(Settings.get_org_name(conn)))
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", printer: printer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    printer = Menu.get_printer!(id)
    {:ok, _printer} = Menu.delete_printer(printer)

    conn
    |> put_flash(:info, "Printer deleted successfully.")
    |> redirect(to: printer_path(conn, :index))
  end

  def toggle_printer(conn, params) do
    rest = Repo.get_by(Restaurant, code: params["code"])

    result =
      Repo.all(
        from(
          r in RestItemPrinter,
          where:
            r.rest_id == ^rest.id and r.printer_id == ^params["printer_id"] and is_nil(r.item_id)
        )
      )

    printer =
      if result == [] do
        # need to create
        {:ok, printer} =
          RestItemPrinter.changeset(%RestItemPrinter{}, %{
            rest_id: rest.id,
            printer_id: params["printer_id"]
          })
          |> Repo.insert()

        printer
      else
        result |> hd()

        # need to delete this record and its child...?
      end

    json_map = [%{stats: "ok"}] |> Poison.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json_map)
  end

  def check_printer(conn, params) do
    rest = Repo.get_by(Restaurant, code: params["code"])

    result =
      Repo.all(
        from(
          r in RestItemPrinter,
          where:
            r.rest_id == ^rest.id and r.printer_id == ^params["printer_id"] and is_nil(r.item_id)
        )
      )

    json_map =
      if result == [] do
        [%{stats: "none"}] |> Poison.encode!()
      else
        [%{stats: "ok"}] |> Poison.encode!()
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json_map)
  end

  def update_printer_item(conn, params) do
    rest = Repo.get_by(Restaurant, code: params["code"])

    old_result =
      Repo.all(
        from(
          r in RestItemPrinter,
          where: r.rest_id == ^rest.id and r.item_id == ^params["item_id"]
        )
      )

    json_map =
      if old_result == [] do
        {:ok, printer} =
          RestItemPrinter.changeset(%RestItemPrinter{}, %{
            rest_id: rest.id,
            printer_id: params["printer_id"],
            item_id: params["item_id"]
          })
          |> Repo.insert()

        [%{stats: "none"}] |> Poison.encode!()
      else
        printer = hd(old_result)

        {:ok, printer} =
          RestItemPrinter.changeset(printer, %{
            rest_id: rest.id,
            printer_id: params["printer_id"],
            item_id: params["item_id"]
          })
          |> Repo.update()

        [%{stats: "ok"}] |> Poison.encode!()
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json_map)
  end

  def check_printer_item(conn, params) do
    rest = Repo.get_by(Restaurant, code: params["code"])

    old_result =
      Repo.all(
        from(
          r in RestItemPrinter,
          left_join: i in Item,
          on: r.item_id == i.id,
          where: r.rest_id == ^rest.id and r.printer_id == ^params["printer_id"],
          select: %{name: i.name, code: i.code, id: i.id}
        )
      )
      |> Enum.reject(fn x -> x.code == nil end)

    json_map =
      if old_result == [] do
        [%{stats: "none", printers: []}] |> Poison.encode!()
      else
        [%{stats: "ok", printers: old_result}] |> Poison.encode!()
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json_map)
  end
end
