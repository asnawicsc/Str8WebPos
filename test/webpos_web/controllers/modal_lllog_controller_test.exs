defmodule WebposWeb.ModalLllogControllerTest do
  use WebposWeb.ConnCase

  alias Webpos.Reports

  @create_attrs %{after_change: "some after_change", before_change: "some before_change", category: "some category", datetime: ~N[2010-04-17 14:00:00.000000], primary_id: 42, user_name: "some user_name", user_type: "some user_type"}
  @update_attrs %{after_change: "some updated after_change", before_change: "some updated before_change", category: "some updated category", datetime: ~N[2011-05-18 15:01:01.000000], primary_id: 43, user_name: "some updated user_name", user_type: "some updated user_type"}
  @invalid_attrs %{after_change: nil, before_change: nil, category: nil, datetime: nil, primary_id: nil, user_name: nil, user_type: nil}

  def fixture(:modal_lllog) do
    {:ok, modal_lllog} = Reports.create_modal_lllog(@create_attrs)
    modal_lllog
  end

  describe "index" do
    test "lists all modallogs", %{conn: conn} do
      conn = get conn, modal_lllog_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Modallogs"
    end
  end

  describe "new modal_lllog" do
    test "renders form", %{conn: conn} do
      conn = get conn, modal_lllog_path(conn, :new)
      assert html_response(conn, 200) =~ "New Modal lllog"
    end
  end

  describe "create modal_lllog" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, modal_lllog_path(conn, :create), modal_lllog: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == modal_lllog_path(conn, :show, id)

      conn = get conn, modal_lllog_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Modal lllog"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, modal_lllog_path(conn, :create), modal_lllog: @invalid_attrs
      assert html_response(conn, 200) =~ "New Modal lllog"
    end
  end

  describe "edit modal_lllog" do
    setup [:create_modal_lllog]

    test "renders form for editing chosen modal_lllog", %{conn: conn, modal_lllog: modal_lllog} do
      conn = get conn, modal_lllog_path(conn, :edit, modal_lllog)
      assert html_response(conn, 200) =~ "Edit Modal lllog"
    end
  end

  describe "update modal_lllog" do
    setup [:create_modal_lllog]

    test "redirects when data is valid", %{conn: conn, modal_lllog: modal_lllog} do
      conn = put conn, modal_lllog_path(conn, :update, modal_lllog), modal_lllog: @update_attrs
      assert redirected_to(conn) == modal_lllog_path(conn, :show, modal_lllog)

      conn = get conn, modal_lllog_path(conn, :show, modal_lllog)
      assert html_response(conn, 200) =~ "some updated after_change"
    end

    test "renders errors when data is invalid", %{conn: conn, modal_lllog: modal_lllog} do
      conn = put conn, modal_lllog_path(conn, :update, modal_lllog), modal_lllog: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Modal lllog"
    end
  end

  describe "delete modal_lllog" do
    setup [:create_modal_lllog]

    test "deletes chosen modal_lllog", %{conn: conn, modal_lllog: modal_lllog} do
      conn = delete conn, modal_lllog_path(conn, :delete, modal_lllog)
      assert redirected_to(conn) == modal_lllog_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, modal_lllog_path(conn, :show, modal_lllog)
      end
    end
  end

  defp create_modal_lllog(_) do
    modal_lllog = fixture(:modal_lllog)
    {:ok, modal_lllog: modal_lllog}
  end
end
