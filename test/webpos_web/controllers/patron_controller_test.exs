defmodule WebposWeb.PatronControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Settings

  @create_attrs %{birthday: "some birthday", name: "some name", phone: "some phone", points: 42, remarks: "some remarks", rest_id: 42}
  @update_attrs %{birthday: "some updated birthday", name: "some updated name", phone: "some updated phone", points: 43, remarks: "some updated remarks", rest_id: 43}
  @invalid_attrs %{birthday: nil, name: nil, phone: nil, points: nil, remarks: nil, rest_id: nil}

  def fixture(:patron) do
    {:ok, patron} = Settings.create_patron(@create_attrs)
    patron
  end

  describe "index" do
    test "lists all patrons", %{conn: conn} do
      conn = get conn, patron_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Patrons"
    end
  end

  describe "new patron" do
    test "renders form", %{conn: conn} do
      conn = get conn, patron_path(conn, :new)
      assert html_response(conn, 200) =~ "New Patron"
    end
  end

  describe "create patron" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, patron_path(conn, :create), patron: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == patron_path(conn, :show, id)

      conn = get conn, patron_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Patron"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, patron_path(conn, :create), patron: @invalid_attrs
      assert html_response(conn, 200) =~ "New Patron"
    end
  end

  describe "edit patron" do
    setup [:create_patron]

    test "renders form for editing chosen patron", %{conn: conn, patron: patron} do
      conn = get conn, patron_path(conn, :edit, patron)
      assert html_response(conn, 200) =~ "Edit Patron"
    end
  end

  describe "update patron" do
    setup [:create_patron]

    test "redirects when data is valid", %{conn: conn, patron: patron} do
      conn = put conn, patron_path(conn, :update, patron), patron: @update_attrs
      assert redirected_to(conn) == patron_path(conn, :show, patron)

      conn = get conn, patron_path(conn, :show, patron)
      assert html_response(conn, 200) =~ "some updated birthday"
    end

    test "renders errors when data is invalid", %{conn: conn, patron: patron} do
      conn = put conn, patron_path(conn, :update, patron), patron: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Patron"
    end
  end

  describe "delete patron" do
    setup [:create_patron]

    test "deletes chosen patron", %{conn: conn, patron: patron} do
      conn = delete conn, patron_path(conn, :delete, patron)
      assert redirected_to(conn) == patron_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, patron_path(conn, :show, patron)
      end
    end
  end

  defp create_patron(_) do
    patron = fixture(:patron)
    {:ok, patron: patron}
  end
end
