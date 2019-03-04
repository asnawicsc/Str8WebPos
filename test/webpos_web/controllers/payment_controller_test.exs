defmodule WebposWeb.PaymentControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Settings

  @create_attrs %{description: "some description", name: "some name", regex: "some regex"}
  @update_attrs %{description: "some updated description", name: "some updated name", regex: "some updated regex"}
  @invalid_attrs %{description: nil, name: nil, regex: nil}

  def fixture(:payment) do
    {:ok, payment} = Settings.create_payment(@create_attrs)
    payment
  end

  describe "index" do
    test "lists all payments", %{conn: conn} do
      conn = get conn, payment_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Payments"
    end
  end

  describe "new payment" do
    test "renders form", %{conn: conn} do
      conn = get conn, payment_path(conn, :new)
      assert html_response(conn, 200) =~ "New Payment"
    end
  end

  describe "create payment" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, payment_path(conn, :create), payment: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == payment_path(conn, :show, id)

      conn = get conn, payment_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Payment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, payment_path(conn, :create), payment: @invalid_attrs
      assert html_response(conn, 200) =~ "New Payment"
    end
  end

  describe "edit payment" do
    setup [:create_payment]

    test "renders form for editing chosen payment", %{conn: conn, payment: payment} do
      conn = get conn, payment_path(conn, :edit, payment)
      assert html_response(conn, 200) =~ "Edit Payment"
    end
  end

  describe "update payment" do
    setup [:create_payment]

    test "redirects when data is valid", %{conn: conn, payment: payment} do
      conn = put conn, payment_path(conn, :update, payment), payment: @update_attrs
      assert redirected_to(conn) == payment_path(conn, :show, payment)

      conn = get conn, payment_path(conn, :show, payment)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, payment: payment} do
      conn = put conn, payment_path(conn, :update, payment), payment: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Payment"
    end
  end

  describe "delete payment" do
    setup [:create_payment]

    test "deletes chosen payment", %{conn: conn, payment: payment} do
      conn = delete conn, payment_path(conn, :delete, payment)
      assert redirected_to(conn) == payment_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, payment_path(conn, :show, payment)
      end
    end
  end

  defp create_payment(_) do
    payment = fixture(:payment)
    {:ok, payment: payment}
  end
end
