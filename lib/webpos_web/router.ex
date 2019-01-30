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

  scope "/", WebposWeb do
    # Use the default browser stack
    pipe_through(:browser)
    get("/", PageController, :index)
    get("/login", UserController, :login)
    post("/authenticate_login", UserController, :authenticate_login)
    get("/logout", UserController, :logout)
    resources("/users", UserController)
    resources("/organizations", OrganizationController)
    get("/:org_name/items", ItemController, :index)
    resources("/restaurants", RestaurantController)
    resources("/items", ItemController)
    get("/items/:item_id/combos", ComboController, :index)
    get("/items/:item_id/combos/new", ComboController, :new)
    resources("/combos", ComboController)
    get("/*path", PageController, :no_page_found)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebposWeb do
  #   pipe_through :api
  # end
end
