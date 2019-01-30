defmodule WebposWeb.Router do
  use WebposWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Webpos.Authorization)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", WebposWeb do
    pipe_through(:api)

    get("/sales", ApiController, :webhook_get)
    post("/sales", ApiController, :webhook_post)

    post("/operations", ApiController, :webhook_post_operations)
  end

  scope "/:organization", WebposWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/*path", PageController, :no_page_found)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebposWeb do
  #   pipe_through :api
  # end
end
