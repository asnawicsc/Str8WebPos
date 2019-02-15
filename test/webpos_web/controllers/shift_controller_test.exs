defmodule WebposWeb.ShiftControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Reports

  @create_attrs %{close_amount: "120.5", closing_staff: "some closing_staff", end_datetime: ~N[2010-04-17 14:00:00.000000], open_amount: "120.5", opening_staff: "some opening_staff", organization_id: 42, rest_id: 42, start_datetime: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{close_amount: "456.7", closing_staff: "some updated closing_staff", end_datetime: ~N[2011-05-18 15:01:01.000000], open_amount: "456.7", opening_staff: "some updated opening_staff", organization_id: 43, rest_id: 43, start_datetime: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{close_amount: nil, closing_staff: nil, end_datetime: nil, open_amount: nil, opening_staff: nil, organization_id: nil, rest_id: nil, start_datetime: nil}

  def fixture(:shift) do
    {:ok, shift} = Reports.create_shift(@create_attrs)
    shift
  end

  describe "index" do
    test "lists all shifts", %{conn: conn} do
      conn = get conn, shift_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Shifts"
    end
  end

  describe "new shift" do
    test "renders form", %{conn: conn} do
      conn = get conn, shift_path(conn, :new)
      assert html_response(conn, 200) =~ "New Shift"
    end
  end

  describe "create shift" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, shift_path(conn, :create), shift: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == shift_path(conn, :show, id)

      conn = get conn, shift_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Shift"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, shift_path(conn, :create), shift: @invalid_attrs
      assert html_response(conn, 200) =~ "New Shift"
    end
  end

  describe "edit shift" do
    setup [:create_shift]

    test "renders form for editing chosen shift", %{conn: conn, shift: shift} do
      conn = get conn, shift_path(conn, :edit, shift)
      assert html_response(conn, 200) =~ "Edit Shift"
    end
  end

  describe "update shift" do
    setup [:create_shift]

    test "redirects when data is valid", %{conn: conn, shift: shift} do
      conn = put conn, shift_path(conn, :update, shift), shift: @update_attrs
      assert redirected_to(conn) == shift_path(conn, :show, shift)

      conn = get conn, shift_path(conn, :show, shift)
      assert html_response(conn, 200) =~ "some updated closing_staff"
    end

    test "renders errors when data is invalid", %{conn: conn, shift: shift} do
      conn = put conn, shift_path(conn, :update, shift), shift: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Shift"
    end
  end

  describe "delete shift" do
    setup [:create_shift]

    test "deletes chosen shift", %{conn: conn, shift: shift} do
      conn = delete conn, shift_path(conn, :delete, shift)
      assert redirected_to(conn) == shift_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, shift_path(conn, :show, shift)
      end
    end
  end

  defp create_shift(_) do
    shift = fixture(:shift)
    {:ok, shift: shift}
  end
end
