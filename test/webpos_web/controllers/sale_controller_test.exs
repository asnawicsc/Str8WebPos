defmodule WebposWeb.SaleControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Reports

  @create_attrs %{discount_description: "some discount_description", discount_name: "some discount_name", discounted_amount: "120.5", grand_total: "120.5", invoiceno: "some invoiceno", pax: 42, rounding: "120.5", salesdate: ~D[2010-04-17], salesdatetime: ~N[2010-04-17 14:00:00.000000], salesid: "some salesid", service_charge: "120.5", staffid: "some staffid", sub_total: "120.5", tax: "120.5", tbl_no: "some tbl_no", transaction_type: "some transaction_type"}
  @update_attrs %{discount_description: "some updated discount_description", discount_name: "some updated discount_name", discounted_amount: "456.7", grand_total: "456.7", invoiceno: "some updated invoiceno", pax: 43, rounding: "456.7", salesdate: ~D[2011-05-18], salesdatetime: ~N[2011-05-18 15:01:01.000000], salesid: "some updated salesid", service_charge: "456.7", staffid: "some updated staffid", sub_total: "456.7", tax: "456.7", tbl_no: "some updated tbl_no", transaction_type: "some updated transaction_type"}
  @invalid_attrs %{discount_description: nil, discount_name: nil, discounted_amount: nil, grand_total: nil, invoiceno: nil, pax: nil, rounding: nil, salesdate: nil, salesdatetime: nil, salesid: nil, service_charge: nil, staffid: nil, sub_total: nil, tax: nil, tbl_no: nil, transaction_type: nil}

  def fixture(:sale) do
    {:ok, sale} = Reports.create_sale(@create_attrs)
    sale
  end

  describe "index" do
    test "lists all sales", %{conn: conn} do
      conn = get conn, sale_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Sales"
    end
  end

  describe "new sale" do
    test "renders form", %{conn: conn} do
      conn = get conn, sale_path(conn, :new)
      assert html_response(conn, 200) =~ "New Sale"
    end
  end

  describe "create sale" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, sale_path(conn, :create), sale: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == sale_path(conn, :show, id)

      conn = get conn, sale_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Sale"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, sale_path(conn, :create), sale: @invalid_attrs
      assert html_response(conn, 200) =~ "New Sale"
    end
  end

  describe "edit sale" do
    setup [:create_sale]

    test "renders form for editing chosen sale", %{conn: conn, sale: sale} do
      conn = get conn, sale_path(conn, :edit, sale)
      assert html_response(conn, 200) =~ "Edit Sale"
    end
  end

  describe "update sale" do
    setup [:create_sale]

    test "redirects when data is valid", %{conn: conn, sale: sale} do
      conn = put conn, sale_path(conn, :update, sale), sale: @update_attrs
      assert redirected_to(conn) == sale_path(conn, :show, sale)

      conn = get conn, sale_path(conn, :show, sale)
      assert html_response(conn, 200) =~ "some updated discount_description"
    end

    test "renders errors when data is invalid", %{conn: conn, sale: sale} do
      conn = put conn, sale_path(conn, :update, sale), sale: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Sale"
    end
  end

  describe "delete sale" do
    setup [:create_sale]

    test "deletes chosen sale", %{conn: conn, sale: sale} do
      conn = delete conn, sale_path(conn, :delete, sale)
      assert redirected_to(conn) == sale_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, sale_path(conn, :show, sale)
      end
    end
  end

  defp create_sale(_) do
    sale = fixture(:sale)
    {:ok, sale: sale}
  end
end
