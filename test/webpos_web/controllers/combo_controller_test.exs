defmodule WebposWeb.ComboControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Menu

  @create_attrs %{category: "some category", category_limit: 42, combo_id: 42, item_id: 42}
  @update_attrs %{category: "some updated category", category_limit: 43, combo_id: 43, item_id: 43}
  @invalid_attrs %{category: nil, category_limit: nil, combo_id: nil, item_id: nil}

  def fixture(:combo) do
    {:ok, combo} = Menu.create_combo(@create_attrs)
    combo
  end

  describe "index" do
    test "lists all combos", %{conn: conn} do
      conn = get conn, combo_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Combos"
    end
  end

  describe "new combo" do
    test "renders form", %{conn: conn} do
      conn = get conn, combo_path(conn, :new)
      assert html_response(conn, 200) =~ "New Combo"
    end
  end

  describe "create combo" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, combo_path(conn, :create), combo: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == combo_path(conn, :show, id)

      conn = get conn, combo_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Combo"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, combo_path(conn, :create), combo: @invalid_attrs
      assert html_response(conn, 200) =~ "New Combo"
    end
  end

  describe "edit combo" do
    setup [:create_combo]

    test "renders form for editing chosen combo", %{conn: conn, combo: combo} do
      conn = get conn, combo_path(conn, :edit, combo)
      assert html_response(conn, 200) =~ "Edit Combo"
    end
  end

  describe "update combo" do
    setup [:create_combo]

    test "redirects when data is valid", %{conn: conn, combo: combo} do
      conn = put conn, combo_path(conn, :update, combo), combo: @update_attrs
      assert redirected_to(conn) == combo_path(conn, :show, combo)

      conn = get conn, combo_path(conn, :show, combo)
      assert html_response(conn, 200) =~ "some updated category"
    end

    test "renders errors when data is invalid", %{conn: conn, combo: combo} do
      conn = put conn, combo_path(conn, :update, combo), combo: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Combo"
    end
  end

  describe "delete combo" do
    setup [:create_combo]

    test "deletes chosen combo", %{conn: conn, combo: combo} do
      conn = delete conn, combo_path(conn, :delete, combo)
      assert redirected_to(conn) == combo_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, combo_path(conn, :show, combo)
      end
    end
  end

  defp create_combo(_) do
    combo = fixture(:combo)
    {:ok, combo: combo}
  end
end
