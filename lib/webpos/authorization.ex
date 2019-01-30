defmodule Webpos.Authorization do
  use Phoenix.Controller, namespace: WebposWeb
  import Plug.Conn
  import Ecto.Query

  require IEx

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    if conn.request_path == "/" do
      conn
    else
      # all these will return a organization name in the url path
      domain_name =
        if check_plug_session_has_organization(conn) do
          if conn.private.plug_session["organization"] != conn.params["organization"] do
            ""
          else
            conn.private.plug_session["organization"]
          end
        else
          # then it will go by the url provided organization name
          if conn.params["organization"] != nil do
            organization =
              Webpos.Repo.get_by(
                Webpos.Settings.Organization,
                domain_name: conn.params["organization"]
              )

            if organization != nil do
              organization.domain_name
            else
              ""
            end
          else
            ""
          end
        end

      if domain_name != "" do
        route_user_organization(conn, domain_name)
      else
        route_user(conn)
      end

      if conn.private.plug_session["user_id"] == nil do
        conn
      else
        if authorize?(conn, domain_name) do
          conn
          |> put_flash(:error, "Unauthorized")
          |> redirect(to: "/#{domain_name}")
          |> halt
        else
          conn
        end
      end
    end
  end

  def check_plug_session_has_organization(conn) do
    conn.private.plug_session["organization"] != nil
  end

  def route_user_organization(conn, organizations) do
    if conn.private.plug_session["user_id"] == nil do
      if conn.request_path == "/#{organizations}/login" or
           conn.request_path == "/#{organizations}/authenticate_login" or
           conn.request_path == "/#{organizations}/forget_password" or
           conn.request_path == "/#{organizations}/forget_password_email" or
           conn.request_path == "/#{organizations}/api/sales" or
           conn.request_path == "/#{organizations}/internal_api" do
        conn
      else
        conn
        |> put_flash(:error, "Please login first!")
        |> redirect(to: "/login")
        |> halt
      end
    else
      conn
    end
  end

  def route_user(conn) do
    if conn.private.plug_session["user_id"] == nil do
      if conn.request_path == "/" or conn.request_path == "/authenticate_login" or
           conn.request_path == "/forget_password" or conn.request_path == "/logout" or
           conn.request_path == "/forget_password_email" or conn.request_path == "/api/sales" do
        conn
      else
        conn
        |> delete_session(:user_id)
        |> delete_session(:organization_id)
        |> delete_session(:organization)
        |> redirect(to: "/")
        |> halt
      end
    else
      if conn.private.plug_session["organization"] == conn.params["organization"] do
        conn
      else
        conn
        |> delete_session(:user_id)
        |> delete_session(:organization_id)
        |> delete_session(:organization)
        |> redirect(to: "/")
        |> halt
      end
    end
  end

  def authorize?(conn, organization) do
    true
  end
end
