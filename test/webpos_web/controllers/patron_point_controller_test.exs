defmodule WebposWeb.PatronPointControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Settings

  @create_attrs %{accumulated: 42, in: 42, out: 42, patron_id: 42, remarks: "some remarks", salesdate: ~D[2010-04-17], salesid: "some salesid"}
  @update_attrs %{accumulated: 43, in: 43, out: 43, patron_id: 43, remarks: "some updated remarks", salesdate: ~D[2011-05-18], salesid: "some updated salesid"}
  @invalid_attrs %{accumulated: nil, in: nil, out: nil, patron_id: nil, remarks: nil, salesdate: nil, salesid: nil}

  def fixture(:patron_point) do
    {:ok, patron_point} = Settings.create_patron_point(@create_attrs)
    patron_point
  end

  describe "index" do
    test "lists all patron_points", %{conn: conn} do
      conn = get conn, patron_point_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Patron points"
    end
  end

  describe "new patron_point" do
    test "renders form", %{conn: conn} do
      conn = get conn, patron_point_path(conn, :new)
      assert html_response(conn, 200) =~ "New Patron point"
    end
  end

  describe "create patron_point" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, patron_point_path(conn, :create), patron_point: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == patron_point_path(conn, :show, id)

      conn = get conn, patron_point_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Patron point"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, patron_point_path(conn, :create), patron_point: @invalid_attrs
      assert html_response(conn, 200) =~ "New Patron point"
    end
  end

  describe "edit patron_point" do
    setup [:create_patron_point]

    test "renders form for editing chosen patron_point", %{conn: conn, patron_point: patron_point} do
      conn = get conn, patron_point_path(conn, :edit, patron_point)
      assert html_response(conn, 200) =~ "Edit Patron point"
    end
  end

  describe "update patron_point" do
    setup [:create_patron_point]

    test "redirects when data is valid", %{conn: conn, patron_point: patron_point} do
      conn = put conn, patron_point_path(conn, :update, patron_point), patron_point: @update_attrs
      assert redirected_to(conn) == patron_point_path(conn, :show, patron_point)

      conn = get conn, patron_point_path(conn, :show, patron_point)
      assert html_response(conn, 200) =~ "some updated remarks"
    end

    test "renders errors when data is invalid", %{conn: conn, patron_point: patron_point} do
      conn = put conn, patron_point_path(conn, :update, patron_point), patron_point: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Patron point"
    end
  end

  describe "delete patron_point" do
    setup [:create_patron_point]

    test "deletes chosen patron_point", %{conn: conn, patron_point: patron_point} do
      conn = delete conn, patron_point_path(conn, :delete, patron_point)
      assert redirected_to(conn) == patron_point_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, patron_point_path(conn, :show, patron_point)
      end
    end
  end

  defp create_patron_point(_) do
    patron_point = fixture(:patron_point)
    {:ok, patron_point: patron_point}
  end
end
