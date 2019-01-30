defmodule Webpos.Authorization do
  use Phoenix.Controller, namespace: WebposWeb
  import Plug.Conn
  import Ecto.Query

  require IEx

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    # check if request path
    # check if logged in
    # else redirect 

    if conn.request_path == "/logout" or conn.request_path == "/login" or
         conn.request_path == "/authenticate_login" do
      conn
    else
      IO.inspect(conn.private.plug_session["user_id"])

      if conn.private.plug_session["user_id"] != nil do
        if authorize?(conn) do
          conn
        else
          conn
          |> put_flash(:error, "Unauthorized")
          |> redirect(to: "/")
          |> halt
        end
      else
        conn
        |> put_flash(:error, "Please login")
        |> redirect(to: "/login")
        |> halt
      end
    end
  end

  def authorize?(conn) do
    true
  end
end
