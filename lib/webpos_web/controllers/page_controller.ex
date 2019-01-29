defmodule WebposWeb.PageController do
  use WebposWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
