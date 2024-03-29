defmodule WebposWeb.RestaurantChannel do
  use WebposWeb, :channel
  require IEx

  def join("restaurant:" <> code, payload, socket) do
    if authorized?(payload, code) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("split_order", payload, socket) do
    code = String.split(socket.topic, ":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()

    order =
      Repo.get_by(
        Order,
        order_id: payload["new"]["id"],
        rest_id: restaurant.id,
        organization_id: restaurant.organization_id,
        salesdatetime: payload["new"]["salesdatetime"]
      )

    a =
      if order != nil do
        Reports.update_order(order, %{
          order_id: payload["new"]["id"],
          items: Poison.encode!(payload["new"]["items"]),
          salesdate: payload["new"]["salesdate"],
          salesdatetime: payload["new"]["salesdatetime"],
          table_id: payload["new"]["table_id"],
          rest_id: restaurant.id,
          organization_id: restaurant.organization_id
        })
      else
        Reports.create_order(%{
          order_id: payload["new"]["id"],
          items: Poison.encode!(payload["new"]["items"]),
          salesdate: payload["new"]["salesdate"],
          salesdatetime: payload["new"]["salesdatetime"],
          table_id: payload["new"]["table_id"],
          rest_id: restaurant.id,
          organization_id: restaurant.organization_id
        })
      end

    order_old =
      Repo.get_by(
        Order,
        order_id: payload["old"]["id"],
        rest_id: restaurant.id,
        organization_id: restaurant.organization_id,
        salesdatetime: payload["old"]["salesdatetime"]
      )

    b =
      if order_old != nil do
        Reports.update_order(order_old, %{
          order_id: payload["old"]["id"],
          items: Poison.encode!(payload["old"]["items"]),
          salesdate: payload["old"]["salesdate"],
          salesdatetime: payload["old"]["salesdatetime"],
          table_id: payload["old"]["table_id"],
          rest_id: restaurant.id,
          organization_id: restaurant.organization_id
        })
      else
        Reports.create_order(%{
          order_id: payload["old"]["id"],
          items: Poison.encode!(payload["old"]["items"]),
          salesdate: payload["old"]["salesdate"],
          salesdatetime: payload["old"]["salesdatetime"],
          table_id: payload["old"]["table_id"],
          rest_id: restaurant.id,
          organization_id: restaurant.organization_id
        })
      end

    IO.inspect(a)
    IO.inspect(b)

    {:noreply, socket}
  end

  def handle_in("combine_order", payload, socket) do
    code = String.split(socket.topic, ":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()

    order =
      Repo.get_by(
        Order,
        order_id: payload["new"]["id"],
        rest_id: restaurant.id,
        organization_id: restaurant.organization_id,
        salesdatetime: payload["new"]["salesdatetime"]
      )

    a =
      if order != nil do
        Reports.update_order(order, %{
          order_id: payload["new"]["id"],
          items: Poison.encode!(payload["new"]["items"]),
          salesdate: payload["new"]["salesdate"],
          salesdatetime: payload["new"]["salesdatetime"],
          table_id: payload["new"]["table_id"],
          rest_id: restaurant.id,
          organization_id: restaurant.organization_id
        })
      else
        Reports.create_order(%{
          order_id: payload["new"]["id"],
          items: Poison.encode!(payload["new"]["items"]),
          salesdate: payload["new"]["salesdate"],
          salesdatetime: payload["new"]["salesdatetime"],
          table_id: payload["new"]["table_id"],
          rest_id: restaurant.id,
          organization_id: restaurant.organization_id
        })
      end

    order_old =
      Repo.get_by(
        Order,
        order_id: payload["old"]["id"],
        rest_id: restaurant.id,
        organization_id: restaurant.organization_id,
        salesdatetime: payload["old"]["salesdatetime"]
      )

    Repo.delete(order_old)

    IO.inspect(a)

    {:noreply, socket}
  end

  def handle_in("update_order", payload, socket) do
    code = String.split(socket.topic, ":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()

    order =
      Repo.get_by(
        Order,
        order_id: payload["id"],
        rest_id: restaurant.id,
        organization_id: restaurant.organization_id,
        salesdatetime: payload["salesdatetime"]
      )

    a =
      if order != nil do
        Reports.update_order(order, %{
          order_id: payload["id"],
          items: Poison.encode!(payload["items"]),
          salesdate: payload["salesdate"],
          salesdatetime: payload["salesdatetime"],
          table_id: payload["table_id"],
          rest_id: restaurant.id,
          organization_id: restaurant.organization_id
        })
      else
        Reports.create_order(%{
          order_id: payload["id"],
          items: Poison.encode!(payload["items"]),
          salesdate: payload["salesdate"],
          salesdatetime: payload["salesdatetime"],
          table_id: payload["table_id"],
          rest_id: restaurant.id,
          organization_id: restaurant.organization_id
        })
      end

    IO.inspect(a)

    {:noreply, socket}
  end

  def handle_in("void_item", payload, socket) do
    code = String.split(socket.topic, ":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()
    item_map = payload["void_item"]

    {:ok, datetime} = DateTime.from_unix(item_map["void_datetime"], :millisecond)

    {:ok, v} =
      Reports.create_void_item(%{
        item_name: item_map["item_name"],
        void_by: item_map["void_by"],
        order_id: item_map["order_id"],
        table_name: item_map["table_name"],
        rest_id: restaurant.id,
        void_datetime: datetime,
        reason: item_map["reason"]
      })

    IO.inspect(v)

    {:noreply, socket}
  end

  def handle_in("query_patron", payload, socket) do
    code = String.split(socket.topic, ":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()
    patron_map = payload["patron"]

    result =
      Repo.get_by(
        Patron,
        rest_id: restaurant.id,
        phone: patron_map["phone"]
      )

    patron =
      if result != nil do
        result
      else
        {:ok, patron} =
          Settings.create_patron(%{
            name: patron_map["name"],
            phone: patron_map["phone"],
            rest_id: restaurant.id
          })

        Settings.create_patron_point(%{
          "patron_id" => patron.id,
          "in" => 0,
          "remarks" => "initial",
          "salesdate" => Timex.today(),
          "salesid" => "0"
        })

        patron
      end

    res =
      Repo.all(
        from(
          p in PatronPoint,
          where: p.patron_id == ^patron.id,
          select: %{
            accumulated: p.accumulated,
            date: p.salesdate,
            remarks: p.remarks,
            in: p.in,
            out: p.out,
            salesid: p.salesid
          },
          order_by: [desc: :id]
        )
      )

    points =
      if res != [] do
        hd(res).accumulated
      else
        0
      end

    salesids = Enum.map(res, fn x -> x.salesid end)

    food_history =
      Repo.all(
        from(
          sd in SalesDetail,
          where: sd.salesid in ^salesids,
          group_by: [sd.itemname],
          select: %{itemname: sd.itemname, qty: sum(sd.qty)}
        )
      )

    IO.inspect(patron)

    order_history =
      Repo.all(
        from(
          sd in SalesDetail,
          left_join: s in Sale,
          on: s.salesid == sd.salesid,
          where: sd.salesid in ^salesids,
          group_by: [sd.itemname, s.salesdate, s.salesid, s.grand_total],
          select: %{
            itemname: sd.itemname,
            qty: sum(sd.qty),
            date: s.salesdate,
            salesid: s.salesid,
            gt: s.grand_total
          }
        )
      )
      |> Enum.group_by(fn x -> x.date end)

    keys = order_history |> Map.keys() |> Enum.reverse()

    final_order =
      for key <- keys do
        %{"#{key}" => order_history[key] |> Enum.group_by(fn x -> x.salesid end)}
      end

    broadcast(socket, "patron_data", %{
      points: points,
      name: patron.name,
      phone: patron.phone,
      food_history: food_history,
      order_history: final_order,
      points_history: res
    })

    {:noreply, socket}
  end

  def handle_in("update_patron", payload, socket) do
    code = String.split(socket.topic, ":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()
    patron_map = payload["patron"]

    result =
      Repo.get_by(
        Patron,
        rest_id: restaurant.id,
        phone: patron_map["phone"]
      )

    patron =
      if result != nil do
        result

        {:ok, patron} =
          Settings.update_patron(result, %{
            name: patron_map["name"]
          })

        patron
      else
        {:ok, patron} =
          Settings.create_patron(%{
            name: patron_map["name"],
            phone: patron_map["phone"],
            rest_id: restaurant.id
          })

        Settings.create_patron_point(%{
          "patron_id" => patron.id,
          "in" => 0,
          "remarks" => "initial",
          "salesdate" => Timex.today(),
          "salesid" => "0"
        })

        patron
      end

    res =
      Repo.all(
        from(
          p in PatronPoint,
          where: p.patron_id == ^patron.id,
          select: %{
            accumulated: p.accumulated,
            date: p.salesdate,
            remarks: p.remarks,
            in: p.in,
            out: p.out,
            salesid: p.salesid
          },
          order_by: [desc: :id]
        )
      )

    points =
      if res != [] do
        hd(res).accumulated
      else
        0
      end

    salesids = Enum.map(res, fn x -> x.salesid end)

    food_history =
      Repo.all(
        from(
          sd in SalesDetail,
          where: sd.salesid in ^salesids,
          group_by: [sd.itemname],
          select: %{itemname: sd.itemname, qty: sum(sd.qty)}
        )
      )

    IO.inspect(patron)

    order_history =
      Repo.all(
        from(
          sd in SalesDetail,
          left_join: s in Sale,
          on: s.salesid == sd.salesid,
          where: sd.salesid in ^salesids,
          group_by: [sd.itemname, s.salesdate, s.salesid, s.grand_total],
          select: %{
            itemname: sd.itemname,
            qty: sum(sd.qty),
            date: s.salesdate,
            salesid: s.salesid,
            gt: s.grand_total
          }
        )
      )
      |> Enum.group_by(fn x -> x.date end)

    keys = order_history |> Map.keys() |> Enum.reverse()

    final_order =
      for key <- keys do
        %{"#{key}" => order_history[key] |> Enum.group_by(fn x -> x.salesid end)}
      end

    broadcast(socket, "patron_data", %{
      points: points,
      name: patron.name,
      phone: patron.phone,
      food_history: food_history,
      order_history: final_order,
      points_history: res
    })

    {:noreply, socket}
  end

  def handle_in("update_table", payload, socket) do
    code = String.split(socket.topic, ":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()
    table_map = payload["table"]

    table =
      Repo.get_by(
        Table,
        rest_table_id: table_map["id"],
        rest_id: restaurant.id
      )

    table =
      if table == nil do
        {:ok, table} =
          Settings.create_table(%{
            name: table_map["name"],
            rest_table_id: table_map["id"],
            pos_x: table_map["dx"],
            pos_y: table_map["dy"],
            rest_id: restaurant.id
          })

        table
      else
        {:ok, table} =
          Settings.update_table(table, %{
            name: table_map["name"],
            rest_table_id: table_map["id"],
            pos_x: table_map["dx"],
            pos_y: table_map["dy"],
            rest_id: restaurant.id
          })

        table
      end

    IO.inspect(table)
    {:noreply, socket}
  end

  def handle_in("get_menu_items", payload, socket) do
    code = String.split(socket.topic, ":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()

    # rest has its own organization pricing(op)
    # each op has many item price
    # each op has 1 item
    items = map_items(restaurant.op_id, restaurant.id)

    broadcast(socket, "new_menu_items", %{menu_items: items})
    {:noreply, socket}
  end

  def map_items(op_id, rest_id) do
    items =
      Repo.all(
        from(
          i in ItemPrice,
          left_join: t in Item,
          on: t.id == i.item_id,
          where: i.op_id == ^op_id and i.price > ^0,
          select: %{
            id: t.id,
            name: t.name,
            category_name: t.category,
            price: i.price,
            img_url: t.img_url,
            customization: t.customizations,
            printer_ip: "10.239.30.114",
            port_no: 9100,
            is_combo: t.is_combo,
            is_available: "Yes"
          }
        )
      )
      |> Enum.map(fn x -> Map.put(x, :customization, customization(x.customization)) end)
      |> Enum.map(fn x -> Map.put(x, :combo_items, combo_items(x.id, x.is_combo, op_id)) end)
      |> Enum.map(fn x -> Map.put(x, :printer_ip, elem(printer(x.id, rest_id), 0)) end)
      |> Enum.map(fn x -> Map.put(x, :port_no, elem(printer(x.id, rest_id), 1)) end)
  end

  def printer(item_id, rest_id) do
    result =
      Repo.all(from(i in RestItemPrinter, where: i.rest_id == ^rest_id and i.item_id == ^item_id))

    printer =
      if result != [] do
        Repo.get(Printer, hd(result).printer_id)
      else
        %{ip_address: "10.239.30.114", port_no: 9100}
      end

    {printer.ip_address, printer.port_no}
  end

  def combo_items(item_id, bool, op_id) do
    if bool do
      Repo.all(
        from(
          c in Combo,
          left_join: p in ComboPrice,
          on: c.combo_id == p.combo_id and c.item_id == p.item_id,
          left_join: i in Item,
          on: i.id == c.item_id and i.id == p.item_id,
          where: c.combo_id == ^item_id,
          select: %{limit: c.category_limit, category: c.category, price: p.price, name: i.name}
        )
      )
    else
      []
    end
  end

  def customization(customizations) do
    if customizations != nil do
      items =
        customizations |> String.split(",") |> Enum.map(fn x -> String.trim(x) end)
        |> Enum.reject(fn x -> x == " " end)

      list = Enum.map(items, fn x -> map_price(x) end)
    end
  end

  def map_price(string) do
    list = string |> String.split("(")

    case Enum.count(list) do
      1 ->
        %{name: hd(list), price: Decimal.new("0.00")}

      2 ->
        %{name: hd(list), price: Decimal.new(String.replace(List.last(list), ")", ""))}

      _ ->
        %{name: "none", price: Decimal.new("0.00")}
    end
  end

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

  def handle_in("order_completed", payload, socket) do
    # broadcast(socket, "shout", payload)
    IO.inspect(payload)
    code = socket.topic |> String.split(":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()

    order =
      Repo.get_by(
        Order,
        order_id: payload["order"]["order_id"],
        rest_id: restaurant.id,
        organization_id: restaurant.organization_id,
        salesdatetime: payload["order"]["salesdatetime"]
      )

    if order != nil do
      Repo.delete(order)
    end

    sales_param = payload["sales"]["sales"]

    sales_param = Map.put(sales_param, "organization_id", restaurant.organization_id)
    sales_param = Map.put(sales_param, "rest_name", restaurant.name)

    case Sale.changeset(%Sale{}, sales_param) |> Repo.insert() do
      {:ok, sl} ->
        for map <- payload["sales"]["sales_details"] do
          sales_detail_param = map

          {:ok, datetime} = DateTime.from_unix(map["inserted_at"], :millisecond)

          sales_detail_param = Map.put(sales_detail_param, "inserted_time", datetime)
          b = SalesDetail.changeset(%SalesDetail{}, sales_detail_param) |> Repo.insert()
          IO.inspect(b)
        end

        for map <- payload["sales"]["sales_payment"] do
          sales_payment_param = map
          # sales_payment_param = Map.put(sales_payment_param, "brand_id", brand_id)

          c =
            SalesPayment.changeset(%SalesPayment{}, sales_payment_param)
            |> Repo.insert()

          IO.inspect(c)
        end

        patron = Repo.get_by(Patron, phone: sales_param["cus_phone"], rest_id: restaurant.id)
        IO.inspect(patron)

        if patron != nil do
          v =
            Settings.create_patron_point(%{
              "patron_id" => patron.id,
              "in" => Kernel.trunc(sales_param["grand_total"] * 100),
              "remarks" => "get points from spending #{sales_param["salesid"]}",
              "salesid" => sales_param["salesid"],
              "salesdate" => sales_param["salesdate"]
            })

          IO.inspect(v)
        end

      {:error, changeset} ->
        IO.inspect(changeset)
    end

    {:noreply, socket}
  end

  def handle_in("open_shift", payload, socket) do
    # broadcast(socket, "shout", payload)
    IO.inspect(payload)
    code = socket.topic |> String.split(":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()
    shiftMap = payload["shift"]

    {:ok, datetime} =
      DateTime.from_unix(String.to_integer(shiftMap["start_datetime"]), :millisecond)

    shiftMap = Map.put(shiftMap, "start_datetime", datetime)
    shiftMap = Map.put(shiftMap, "organization_id", restaurant.organization_id)
    shiftMap = Map.put(shiftMap, "rest_id", restaurant.id)

    result =
      Repo.all(
        from(
          s in Shift,
          where:
            s.opening_staff == ^shiftMap["opening_staff"] and s.start_datetime == ^datetime and
              s.organization_id == ^restaurant.organization_id and s.rest_id == ^restaurant.id
        )
      )

    if result == [] do
      a = Shift.changeset(%Shift{}, shiftMap) |> Repo.insert()
      IO.inspect(a)
    end

    {:noreply, socket}
  end

  def handle_in("close_shift", payload, socket) do
    # broadcast(socket, "shout", payload)
    IO.inspect(payload)
    code = socket.topic |> String.split(":") |> List.last()
    restaurant = Repo.all(from(b in Restaurant, where: b.code == ^code)) |> List.first()
    shiftMap = payload["shift"]

    {:ok, sdatetime} =
      DateTime.from_unix(String.to_integer(shiftMap["start_datetime"]), :millisecond)

    shiftMap = Map.put(shiftMap, "start_datetime", sdatetime)

    {:ok, edatetime} =
      DateTime.from_unix(String.to_integer(shiftMap["end_datetime"]), :millisecond)

    shiftMap = Map.put(shiftMap, "end_datetime", edatetime)

    shiftMap = Map.put(shiftMap, "organization_id", restaurant.organization_id)
    shiftMap = Map.put(shiftMap, "rest_id", restaurant.id)

    result =
      Repo.all(
        from(
          s in Shift,
          where:
            s.opening_staff == ^shiftMap["opening_staff"] and s.start_datetime == ^sdatetime and
              s.organization_id == ^restaurant.organization_id and s.rest_id == ^restaurant.id
        )
      )

    if result != [] do
      a = Shift.changeset(hd(result), shiftMap) |> Repo.update()
      IO.inspect(a)
    end

    {:noreply, socket}
  end
end
