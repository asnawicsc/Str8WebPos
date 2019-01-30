defmodule WebposWeb.OrganizationPriceControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Menu

  @create_attrs %{name: "some name", organization_id: 42}
  @update_attrs %{name: "some updated name", organization_id: 43}
  @invalid_attrs %{name: nil, organization_id: nil}

  def fixture(:organization_price) do
    {:ok, organization_price} = Menu.create_organization_price(@create_attrs)
    organization_price
  end

  describe "index" do
    test "lists all organization_price", %{conn: conn} do
      conn = get conn, organization_price_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Organization price"
    end
  end

  describe "new organization_price" do
    test "renders form", %{conn: conn} do
      conn = get conn, organization_price_path(conn, :new)
      assert html_response(conn, 200) =~ "New Organization price"
    end
  end

  describe "create organization_price" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, organization_price_path(conn, :create), organization_price: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == organization_price_path(conn, :show, id)

      conn = get conn, organization_price_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Organization price"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, organization_price_path(conn, :create), organization_price: @invalid_attrs
      assert html_response(conn, 200) =~ "New Organization price"
    end
  end

  describe "edit organization_price" do
    setup [:create_organization_price]

    test "renders form for editing chosen organization_price", %{conn: conn, organization_price: organization_price} do
      conn = get conn, organization_price_path(conn, :edit, organization_price)
      assert html_response(conn, 200) =~ "Edit Organization price"
    end
  end

  describe "update organization_price" do
    setup [:create_organization_price]

    test "redirects when data is valid", %{conn: conn, organization_price: organization_price} do
      conn = put conn, organization_price_path(conn, :update, organization_price), organization_price: @update_attrs
      assert redirected_to(conn) == organization_price_path(conn, :show, organization_price)

      conn = get conn, organization_price_path(conn, :show, organization_price)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, organization_price: organization_price} do
      conn = put conn, organization_price_path(conn, :update, organization_price), organization_price: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Organization price"
    end
  end

  describe "delete organization_price" do
    setup [:create_organization_price]

    test "deletes chosen organization_price", %{conn: conn, organization_price: organization_price} do
      conn = delete conn, organization_price_path(conn, :delete, organization_price)
      assert redirected_to(conn) == organization_price_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, organization_price_path(conn, :show, organization_price)
      end
    end
  end

  defp create_organization_price(_) do
    organization_price = fixture(:organization_price)
    {:ok, organization_price: organization_price}
  end
end
