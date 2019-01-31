defmodule WebposWeb.RestaurantChannel do
  use WebposWeb, :channel

  def join("restaurant:" <> code, payload, socket) do
    if authorized?(payload, code) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # def handle_in("order_completed", payload, socket) do
  #   # broadcast(socket, "shout", payload)
  #   IO.inspect(payload)
  #   code = socket.topic |> String.split(":") |> List.last()
  #   Restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()

  #   brand_id = Restaurant.brand_id()
  #   sales_param = payload["sales"]["sales"]
  #   sales_param = Map.put(sales_param, "brand_id", brand_id)
  #   sales_param = Map.put(sales_param, "Restaurantid", Integer.to_string(Restaurant.Restaurantid))
  #   a = Sales.changeset(%Sales{}, sales_param) |> Repo.insert()
  #   IO.inspect(a)

  #   for map <- payload["sales"]["sales_details"] do
  #     sales_detail_param = map
  #     sales_detail_param = Map.put(sales_detail_param, "brand_id", brand_id)
  #     b = SalesDetail.changeset(%SalesDetail{}, sales_detail_param) |> Repo.insert()
  #     IO.inspect(b)
  #   end

  #   for map <- payload["sales"]["sales_payment"] do
  #     sales_payment_param = map
  #     sales_payment_param = Map.put(sales_payment_param, "brand_id", brand_id)

  #     c =
  #       SalesPayment.changeset(%SalesPayment{}, sales_payment_param)
  #       |> Repo.insert()

  #     IO.inspect(c)
  #   end

  #   {:noreply, socket}
  # end

  def handle_in("get_menu_items", payload, socket) do
    code = String.split(socket.topic, ":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()

    # rest has its own organization pricing(op)
    # each op has many item price
    # each op has 1 item
    items =
      Repo.all(
        from(
          i in ItemPrice,
          left_join: t in Item,
          on: t.id == i.item_id,
          where: i.op_id == ^1,
          select: %{
            id: t.id,
            name: t.name,
            category: t.category,
            price: i.price,
            img_url: t.img_url
          }
        )
      )

    broadcast(socket, "new_menu_items", %{menu_items: items})
    {:noreply, socket}
  end

  # def handle_in("get_combo_items", payload, socket) do
  #   code = String.split(socket.topic, ":") |> List.last()
  #   Restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()

  #   menu_catalog =
  #     Repo.all(from(m in MenuCatalog, where: m.id == ^Restaurant.menu_catalog())) |> List.first()

  #   combo_items_header =
  #     Repo.all(
  #       from(
  #         i in Webpos.BN.ItemSubcat,
  #         left_join: r in Webpos.BN.SubcatCatalog,
  #         on: r.subcat_id == i.subcatid,
  #         left_join: f in Webpos.BN.Tag,
  #         on: f.printer == i.printer,
  #         where:
  #           i.brand_id == ^menu_catalog.brand_id and r.brand_id == ^menu_catalog.brand_id and
  #             r.catalog_id == ^menu_catalog.id and r.is_active == ^1 and r.is_combo == ^1 and
  #             f.tagdesc == i.tagdesc,
  #         select: %{
  #           name: i.itemname,
  #           price: r.price,
  #           start_date: r.start_date,
  #           end_date: r.end_date,
  #           printer_ip: f.printer_ip,
  #           port_no: f.port_no
  #         }
  #       )
  #     )

  #   sub_combo_item =
  #     Repo.all(
  #       from(
  #         i in Webpos.BN.ComboDetails,
  #         left_join: r in Webpos.BN.ComboCatalog,
  #         on: r.id == i.combo_item_id,
  #         left_join: t in Webpos.BN.ItemCat,
  #         on: t.id == i.menu_cat_id,
  #         where:
  #           i.brand_id == ^menu_catalog.brand_id and t.brand_id == ^menu_catalog.brand_id and
  #             r.brand_id == ^menu_catalog.brand_id and r.catalog_id == ^menu_catalog.id and
  #             r.is_active == ^1 and r.is_combo == 1,
  #         select: %{
  #           name: i.combo_item_name,
  #           price: r.price,
  #           to_up: r.to_up,
  #           category_limit: i.combo_qty,
  #           category_name: t.itemcatname
  #         }
  #       )
  #     )

  #   broadcast(socket, "new_combo_items", %{
  #     combo_items_header: combo_items_header,
  #     sub_combo_item: sub_combo_item
  #   })

  #   {:noreply, socket}
  # end

  def customization(target_item, brand_id) do
    Repo.all(
      from(
        i in Remark,
        where: i.target_item == ^target_item and i.brand_id == ^brand_id,
        select: %{
          id: i.itemsremarkid,
          name: i.remark,
          price: i.price
        }
      )
    )
    |> Poison.encode!()
  end

  # EcomBackendWeb.Endpoint.broadcast(topic, event, message)
  # Add authorization logic here as required.
  defp authorized?(payload, code) do
    IO.inspect(payload)
    restaurants = Repo.all(from(b in Restaurant, where: b.code == ^code))

    restaurant =
      if restaurants != [] do
        restaurants |> List.first()
      else
        %{key: nil}
      end

    payload["license_key"] == restaurant.key
  end
end
