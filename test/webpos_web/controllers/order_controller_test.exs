defmodule WebposWeb.OrderControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Report

  @create_attrs %{items: "some items", order_id: 42, organization_id: 42, rest_id: 42, salesdate: ~D[2010-04-17], salesdatetime: ~N[2010-04-17 14:00:00.000000], table_id: 42}
  @update_attrs %{items: "some updated items", order_id: 43, organization_id: 43, rest_id: 43, salesdate: ~D[2011-05-18], salesdatetime: ~N[2011-05-18 15:01:01.000000], table_id: 43}
  @invalid_attrs %{items: nil, order_id: nil, organization_id: nil, rest_id: nil, salesdate: nil, salesdatetime: nil, table_id: nil}

  def fixture(:order) do
    {:ok, order} = Report.create_order(@create_attrs)
    order
  end

  describe "index" do
    test "lists all orders", %{conn: conn} do
      conn = get conn, order_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Orders"
    end
  end

  describe "new order" do
    test "renders form", %{conn: conn} do
      conn = get conn, order_path(conn, :new)
      assert html_response(conn, 200) =~ "New Order"
    end
  end

  describe "create order" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, order_path(conn, :create), order: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == order_path(conn, :show, id)

      conn = get conn, order_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Order"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, order_path(conn, :create), order: @invalid_attrs
      assert html_response(conn, 200) =~ "New Order"
    end
  end

  describe "edit order" do
    setup [:create_order]

    test "renders form for editing chosen order", %{conn: conn, order: order} do
      conn = get conn, order_path(conn, :edit, order)
      assert html_response(conn, 200) =~ "Edit Order"
    end
  end

  describe "update order" do
    setup [:create_order]

    test "redirects when data is valid", %{conn: conn, order: order} do
      conn = put conn, order_path(conn, :update, order), order: @update_attrs
      assert redirected_to(conn) == order_path(conn, :show, order)

      conn = get conn, order_path(conn, :show, order)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, order: order} do
      conn = put conn, order_path(conn, :update, order), order: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Order"
    end
  end

  describe "delete order" do
    setup [:create_order]

    test "deletes chosen order", %{conn: conn, order: order} do
      conn = delete conn, order_path(conn, :delete, order)
      assert redirected_to(conn) == order_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, order_path(conn, :show, order)
      end
    end
  end

  defp create_order(_) do
    order = fixture(:order)
    {:ok, order: order}
  end
end
