defmodule WebposWeb.VoidItemControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Reports

  @create_attrs %{item_name: "some item_name", order_id: "some order_id", reason: "some reason", rest_id: "some rest_id", table_name: "some table_name", void_by: "some void_by", void_datetime: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{item_name: "some updated item_name", order_id: "some updated order_id", reason: "some updated reason", rest_id: "some updated rest_id", table_name: "some updated table_name", void_by: "some updated void_by", void_datetime: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{item_name: nil, order_id: nil, reason: nil, rest_id: nil, table_name: nil, void_by: nil, void_datetime: nil}

  def fixture(:void_item) do
    {:ok, void_item} = Reports.create_void_item(@create_attrs)
    void_item
  end

  describe "index" do
    test "lists all void_items", %{conn: conn} do
      conn = get conn, void_item_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Void items"
    end
  end

  describe "new void_item" do
    test "renders form", %{conn: conn} do
      conn = get conn, void_item_path(conn, :new)
      assert html_response(conn, 200) =~ "New Void item"
    end
  end

  describe "create void_item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, void_item_path(conn, :create), void_item: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == void_item_path(conn, :show, id)

      conn = get conn, void_item_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Void item"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, void_item_path(conn, :create), void_item: @invalid_attrs
      assert html_response(conn, 200) =~ "New Void item"
    end
  end

  describe "edit void_item" do
    setup [:create_void_item]

    test "renders form for editing chosen void_item", %{conn: conn, void_item: void_item} do
      conn = get conn, void_item_path(conn, :edit, void_item)
      assert html_response(conn, 200) =~ "Edit Void item"
    end
  end

  describe "update void_item" do
    setup [:create_void_item]

    test "redirects when data is valid", %{conn: conn, void_item: void_item} do
      conn = put conn, void_item_path(conn, :update, void_item), void_item: @update_attrs
      assert redirected_to(conn) == void_item_path(conn, :show, void_item)

      conn = get conn, void_item_path(conn, :show, void_item)
      assert html_response(conn, 200) =~ "some updated item_name"
    end

    test "renders errors when data is invalid", %{conn: conn, void_item: void_item} do
      conn = put conn, void_item_path(conn, :update, void_item), void_item: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Void item"
    end
  end

  describe "delete void_item" do
    setup [:create_void_item]

    test "deletes chosen void_item", %{conn: conn, void_item: void_item} do
      conn = delete conn, void_item_path(conn, :delete, void_item)
      assert redirected_to(conn) == void_item_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, void_item_path(conn, :show, void_item)
      end
    end
  end

  defp create_void_item(_) do
    void_item = fixture(:void_item)
    {:ok, void_item: void_item}
  end
end
