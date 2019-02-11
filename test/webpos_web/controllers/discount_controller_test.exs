defmodule WebposWeb.DiscountControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Menu

  @create_attrs %{amount: 120.5, category: "some category", description: "some description", disc_type: "some disc_type", name: "some name", requirements: "some requirements", targets: "some targets"}
  @update_attrs %{amount: 456.7, category: "some updated category", description: "some updated description", disc_type: "some updated disc_type", name: "some updated name", requirements: "some updated requirements", targets: "some updated targets"}
  @invalid_attrs %{amount: nil, category: nil, description: nil, disc_type: nil, name: nil, requirements: nil, targets: nil}

  def fixture(:discount) do
    {:ok, discount} = Menu.create_discount(@create_attrs)
    discount
  end

  describe "index" do
    test "lists all discounts", %{conn: conn} do
      conn = get conn, discount_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Discounts"
    end
  end

  describe "new discount" do
    test "renders form", %{conn: conn} do
      conn = get conn, discount_path(conn, :new)
      assert html_response(conn, 200) =~ "New Discount"
    end
  end

  describe "create discount" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, discount_path(conn, :create), discount: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == discount_path(conn, :show, id)

      conn = get conn, discount_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Discount"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, discount_path(conn, :create), discount: @invalid_attrs
      assert html_response(conn, 200) =~ "New Discount"
    end
  end

  describe "edit discount" do
    setup [:create_discount]

    test "renders form for editing chosen discount", %{conn: conn, discount: discount} do
      conn = get conn, discount_path(conn, :edit, discount)
      assert html_response(conn, 200) =~ "Edit Discount"
    end
  end

  describe "update discount" do
    setup [:create_discount]

    test "redirects when data is valid", %{conn: conn, discount: discount} do
      conn = put conn, discount_path(conn, :update, discount), discount: @update_attrs
      assert redirected_to(conn) == discount_path(conn, :show, discount)

      conn = get conn, discount_path(conn, :show, discount)
      assert html_response(conn, 200) =~ "some updated category"
    end

    test "renders errors when data is invalid", %{conn: conn, discount: discount} do
      conn = put conn, discount_path(conn, :update, discount), discount: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Discount"
    end
  end

  describe "delete discount" do
    setup [:create_discount]

    test "deletes chosen discount", %{conn: conn, discount: discount} do
      conn = delete conn, discount_path(conn, :delete, discount)
      assert redirected_to(conn) == discount_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, discount_path(conn, :show, discount)
      end
    end
  end

  defp create_discount(_) do
    discount = fixture(:discount)
    {:ok, discount: discount}
  end
end
