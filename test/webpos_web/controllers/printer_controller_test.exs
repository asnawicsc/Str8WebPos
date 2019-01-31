defmodule WebposWeb.PrinterControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Menu

  @create_attrs %{ip_address: "some ip_address", name: "some name", organization_id: 42, port_no: "some port_no"}
  @update_attrs %{ip_address: "some updated ip_address", name: "some updated name", organization_id: 43, port_no: "some updated port_no"}
  @invalid_attrs %{ip_address: nil, name: nil, organization_id: nil, port_no: nil}

  def fixture(:printer) do
    {:ok, printer} = Menu.create_printer(@create_attrs)
    printer
  end

  describe "index" do
    test "lists all printers", %{conn: conn} do
      conn = get conn, printer_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Printers"
    end
  end

  describe "new printer" do
    test "renders form", %{conn: conn} do
      conn = get conn, printer_path(conn, :new)
      assert html_response(conn, 200) =~ "New Printer"
    end
  end

  describe "create printer" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, printer_path(conn, :create), printer: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == printer_path(conn, :show, id)

      conn = get conn, printer_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Printer"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, printer_path(conn, :create), printer: @invalid_attrs
      assert html_response(conn, 200) =~ "New Printer"
    end
  end

  describe "edit printer" do
    setup [:create_printer]

    test "renders form for editing chosen printer", %{conn: conn, printer: printer} do
      conn = get conn, printer_path(conn, :edit, printer)
      assert html_response(conn, 200) =~ "Edit Printer"
    end
  end

  describe "update printer" do
    setup [:create_printer]

    test "redirects when data is valid", %{conn: conn, printer: printer} do
      conn = put conn, printer_path(conn, :update, printer), printer: @update_attrs
      assert redirected_to(conn) == printer_path(conn, :show, printer)

      conn = get conn, printer_path(conn, :show, printer)
      assert html_response(conn, 200) =~ "some updated ip_address"
    end

    test "renders errors when data is invalid", %{conn: conn, printer: printer} do
      conn = put conn, printer_path(conn, :update, printer), printer: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Printer"
    end
  end

  describe "delete printer" do
    setup [:create_printer]

    test "deletes chosen printer", %{conn: conn, printer: printer} do
      conn = delete conn, printer_path(conn, :delete, printer)
      assert redirected_to(conn) == printer_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, printer_path(conn, :show, printer)
      end
    end
  end

  defp create_printer(_) do
    printer = fixture(:printer)
    {:ok, printer: printer}
  end
end
