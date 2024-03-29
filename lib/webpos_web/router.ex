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
    get("/:code/get_api2", RestaurantController, :get_api2)
    get("/sales", PageController, :webhook_get)
    post("/sales", PageController, :webhook_post)

    post("/operations", PageController, :webhook_post_operations)
    get("/tree", PageController, :tree_get)
    post("/tree", PageController, :tree_post)
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
    get("/:org_name/restaurants", RestaurantController, :index)
    get("/:org_name/restaurants/:id", RestaurantController, :show)
    resources("/restaurants", RestaurantController)
    resources("/items", ItemController)
    get("/items/:item_id/combos", ComboController, :index)
    get("/items/:item_id/combos/new", ComboController, :new)
    resources("/combos", ComboController)
    get("/organization/:org_id/organization_prices", OrganizationPriceController, :index)
    get("/organization/:org_id/organization_prices/new", OrganizationPriceController, :new)

    resources("/organization_price", OrganizationPriceController)
    post("/update_item_price", OrganizationPriceController, :update_item_price)
    get("/:org_name/get_item_price", OrganizationPriceController, :get_item_price)
    get("/:org_name/get_combo_price", OrganizationPriceController, :get_combo_price)
    get("/:org_name/printers", PrinterController, :index)
    get("/:org_name/printers/new", PrinterController, :new)
    get("/:org_name/toggle_printer", PrinterController, :toggle_printer)
    get("/:org_name/check_printer", PrinterController, :check_printer)
    get("/:org_name/update_printer_item", PrinterController, :update_printer_item)
    get("/:org_name/check_printer_item", PrinterController, :check_printer_item)
    resources("/printers", PrinterController)
    get("/:org_name/discounts", DiscountController, :index)
    get("/:org_name/discounts/new", DiscountController, :new)
    get("/:org_name/discounts/:id/edit", DiscountController, :edit)
    get("/:org_name/toggle_discount", DiscountController, :toggle_discount)
    get("/:org_name/check_discount", DiscountController, :check_discount)
    resources("/discounts", DiscountController)
    resources("/reports/sales", SaleController)
    get("/reports/sales/:code/:invoice", SaleController, :sync)
    resources("/modallogs", ModalLllogController)
    get("/service_charge_excel", PageController, :service_charge_excel)
    get("/discount_analysis_excel", PageController, :discount_analysis_excel)
    get("/item_sales_analysis_excel", PageController, :item_sales_analysis_excel)
    get("/item_sales_overview_excel", PageController, :item_sales_overview_excel)

    resources("/shifts", ShiftController)

    get(
      "/organizations/:branch/sales_details/:output/:start_date/:end_date",
      PageController,
      :sales_details
    )

    get(
      "/test/:code",
      SaleController,
      :test
    )

    get(
      "/organizations/:branch/sales_by_category/:output/:start_date/:end_date",
      PageController,
      :sales_by_category
    )

    get(
      "/organizations/:branch/top_10_sales/:output/:start_date/:end_date",
      PageController,
      :top_10_sales
    )

    get(
      "/organizations/:branch/hourlysales/:output/:start_date/:end_date",
      PageController,
      :hourly_sales
    )

    get(
      "/organizations/:branch/discountsales/:output/:start_date/:end_date",
      PageController,
      :discountsales
    )

    get("/organization/:org_id/payment_type/new", OrganizationController, :payment_type)

    resources("/payments", PaymentController)
    resources("/tables", TableController)
    resources("/void_items", VoidItemController)
    resources("/orders", OrderController)
    resources("/patrons", PatronController)
    resources("/patron_points", PatronPointController)

    get("/*path", PageController, :no_page_found)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebposWeb do
  #   pipe_through :api
  # end
end
