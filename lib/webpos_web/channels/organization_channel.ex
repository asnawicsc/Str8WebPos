defmodule WebposWeb.OrganizationChannel do
  use WebposWeb, :channel

  def join("organization:" <> code, payload, socket) do
    if authorized?(payload, code) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (organization:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(payload, code) do
    IO.inspect(payload)
    organization = Repo.get_by(Organization, code: code)
    IO.inspect(payload["license_key"])
    password = Comeonin.Bcrypt.hashpwsalt(payload["license_key"])
    IO.inspect(organization)

    organization =
      if organization != nil do
        user =
          Repo.all(
            from(s in User,
              where: s.organization_id == ^organization.id
            )
          )

        check =
          for item <- user do
            pass =
              if Comeonin.Bcrypt.checkpw(payload["license_key"], item.crypted_password) == true do
                %{password: payload["license_key"]}
              else
                %{password: nil}
              end

            pass
          end

        trr = Enum.filter(check, fn x -> x.password != nil end)

        user =
          if trr != [] do
            check = trr |> hd

            %{password: check.password}
          else
            %{password: nil}
          end

        IO.inspect(user)
        user
      else
        %{password: nil}
      end

    IO.inspect(organization.password)

    IO.inspect(payload["license_key"])

    a = payload["license_key"] == organization.password
    IO.inspect(a)

    a
  end

  def handle_in("yearly_sales", payload, socket) do
    # broadcast(socket, "shout", payload)
    IO.inspect(payload["date_start"])
    IO.inspect(payload["date_end"])

    IO.inspect(payload)
    IO.inspect(socket)

    date_start = Date.from_iso8601!(payload["date_start"])
    date_end = Date.from_iso8601!(payload["date_end"])

    list = Date.range(date_start, date_end)

    list_year = list |> Enum.map(fn x -> x.year end) |> Enum.uniq()

    sales =
      Repo.all(
        from(
          i in Reports.Sale,
          where: i.salesdate >= ^date_start and i.salesdate <= ^date_end,
          select: %{
            salesdate: i.salesdate,
            sales: i.grand_total
          }
        )
      )

    final =
      for item <- list_year do
        sales = sales |> Enum.filter(fn x -> x.salesdate.year == item end)

        total =
          if sales == [] do
            %{year: item, sales: 0}
          else
            sales =
              sales
              |> Enum.map(fn x -> Decimal.to_float(x.sales) end)
              |> Enum.sum()
              |> Float.round(2)

            %{year: item, sales: sales}
          end

        total
      end

    IO.inspect(final)

    broadcast(socket, "yearly_sales_reply", %{result: final})
    {:noreply, socket}
  end

  def handle_in("monthly_sales", payload, socket) do
    # broadcast(socket, "shout", payload)
    IO.inspect(payload["date_start"])
    IO.inspect(payload["date_end"])

    IO.inspect(payload)
    IO.inspect(socket)

    date_start = Date.from_iso8601!(payload["date_start"])
    date_end = Date.from_iso8601!(payload["date_end"])

    list = Date.range(date_start, date_end)

    list_month = list |> Enum.map(fn x -> x.month end) |> Enum.uniq()

    sales =
      Repo.all(
        from(
          i in Reports.Sale,
          where: i.salesdate >= ^date_start and i.salesdate <= ^date_end,
          select: %{
            salesdate: i.salesdate,
            sales: i.grand_total
          }
        )
      )

    final =
      for item <- list_month do
        sales = sales |> Enum.filter(fn x -> x.salesdate.month == item end)

        total =
          if sales == [] do
            %{month: item, sales: 0}
          else
            sales =
              sales
              |> Enum.map(fn x -> Decimal.to_float(x.sales) end)
              |> Enum.sum()
              |> Float.round(2)

            %{month: item, sales: sales}
          end

        total
      end

    IO.inspect(final)

    broadcast(socket, "monthly_sales_reply", %{result: final})
    {:noreply, socket}
  end

  def handle_in("daily_sales", payload, socket) do
    # broadcast(socket, "shout", payload)
    IO.inspect(payload["date_start"])
    IO.inspect(payload["date_end"])

    IO.inspect(payload)
    IO.inspect(socket)

    date_start = Date.from_iso8601!(payload["date_start"])
    date_end = Date.from_iso8601!(payload["date_end"])

    list = Date.range(date_start, date_end)

    list_day = list |> Enum.map(fn x -> x.day end) |> Enum.uniq()

    sales =
      Repo.all(
        from(
          i in Reports.Sale,
          where: i.salesdate >= ^date_start and i.salesdate <= ^date_end,
          select: %{
            salesdate: i.salesdate,
            sales: i.grand_total
          }
        )
      )

    final =
      for item <- list_day do
        sales = sales |> Enum.filter(fn x -> x.salesdate.day == item end)

        total =
          if sales == [] do
            %{day: item, sales: 0}
          else
            sales =
              sales
              |> Enum.map(fn x -> Decimal.to_float(x.sales) end)
              |> Enum.sum()
              |> Float.round(2)

            %{day: item, sales: sales}
          end

        total
      end

    IO.inspect(final)

    broadcast(socket, "daily_sales_reply", %{result: final})
    {:noreply, socket}
  end

  def handle_in("top_10_item", payload, socket) do
    # broadcast(socket, "shout", payload)
    IO.inspect(payload["date_start"])
    IO.inspect(payload["date_end"])

    IO.inspect(payload)
    IO.inspect(socket)

    date_start = Date.from_iso8601!(payload["date_start"])
    date_end = Date.from_iso8601!(payload["date_end"])

    final =
      Repo.all(
        from(i in Reports.Sale,
          left_join: p in Reports.SalesDetail,
          on: i.salesid == p.salesid,
          where: i.salesdate >= ^date_start and i.salesdate <= ^date_end,
          group_by: [p.itemname],
          order_by: [desc: sum(p.sub_total)],
          select: %{
            item: p.itemname,
            sales: sum(p.sub_total)
          },
          limit: 10
        )
      )
      |> Enum.filter(fn x -> x.item != nil end)

    IO.inspect(final)

    broadcast(socket, "top_10_item_reply", %{result: final})
    {:noreply, socket}
  end

  def handle_in("today_sales", payload, socket) do
    # broadcast(socket, "shout", payload)
    IO.inspect(payload["date_start"])
    IO.inspect(payload["date_end"])

    IO.inspect(payload)
    IO.inspect(socket)

    date_start = Date.from_iso8601!(payload["date_start"])
    date_end = Date.from_iso8601!(payload["date_end"])

    list = Date.range(date_start, date_end)

    list_day = list |> Enum.map(fn x -> x.day end) |> Enum.uniq()

    sales =
      Repo.all(
        from(
          i in Reports.Sale,
          where: i.salesdate >= ^date_start and i.salesdate <= ^date_end,
          select: %{
            salesdate: i.salesdate,
            sales: i.grand_total
          }
        )
      )

    final =
      for item <- list_day do
        sales = sales |> Enum.filter(fn x -> x.salesdate.day == item end)

        total =
          if sales == [] do
            %{day: item, sales: 0}
          else
            sales =
              sales
              |> Enum.map(fn x -> Decimal.to_float(x.sales) end)
              |> Enum.sum()
              |> Float.round(2)

            %{day: item, sales: sales}
          end

        total
      end

    IO.inspect(final)

    broadcast(socket, "today_sales_reply", %{result: final})
    {:noreply, socket}
  end

  def handle_in("this_week_sales", payload, socket) do
    # broadcast(socket, "shout", payload)
    IO.inspect(payload["date_start"])
    IO.inspect(payload["date_end"])

    IO.inspect(payload)
    IO.inspect(socket)

    date = Date.from_iso8601!(payload["date_start"])

    list = Date.range(Timex.beginning_of_week(date), Timex.end_of_week(date))

    list_day = list |> Enum.map(fn x -> x.day end) |> Enum.uniq()

    date_start = Timex.beginning_of_week(date)

    date_end = Timex.end_of_week(date)

    sales =
      Repo.all(
        from(
          i in Reports.Sale,
          where: i.salesdate >= ^date_start and i.salesdate <= ^date_end,
          select: %{
            salesdate: i.salesdate,
            sales: i.grand_total
          }
        )
      )

    final =
      for item <- list_day do
        sales = sales |> Enum.filter(fn x -> x.salesdate.day == item end)

        total =
          if sales == [] do
            %{day: item, sales: 0}
          else
            sales =
              sales
              |> Enum.map(fn x -> Decimal.to_float(x.sales) end)
              |> Enum.sum()
              |> Float.round(2)

            %{day: item, sales: sales}
          end

        total
      end

    IO.inspect(final)

    broadcast(socket, "this_week_sales_reply", %{result: final})
    {:noreply, socket}
  end

  def handle_in("this_month_sales", payload, socket) do
    # broadcast(socket, "shout", payload)
    IO.inspect(payload["date_start"])
    IO.inspect(payload["date_end"])

    IO.inspect(payload)
    IO.inspect(socket)

    date = Date.from_iso8601!(payload["date_start"])

    list = Date.range(Timex.beginning_of_month(date), Timex.end_of_month(date))

    list_day = list |> Enum.map(fn x -> x.day end) |> Enum.uniq()

    date_start = Timex.beginning_of_month(date)

    date_end = Timex.end_of_month(date)

    sales =
      Repo.all(
        from(
          i in Reports.Sale,
          where: i.salesdate >= ^date_start and i.salesdate <= ^date_end,
          select: %{
            salesdate: i.salesdate,
            sales: i.grand_total
          }
        )
      )

    final =
      for item <- list_day do
        sales = sales |> Enum.filter(fn x -> x.salesdate.day == item end)

        total =
          if sales == [] do
            %{day: item, sales: 0}
          else
            sales =
              sales
              |> Enum.map(fn x -> Decimal.to_float(x.sales) end)
              |> Enum.sum()
              |> Float.round(2)

            %{day: item, sales: sales}
          end

        total
      end

    IO.inspect(final)

    broadcast(socket, "this_month_sales_reply", %{result: final})
    {:noreply, socket}
  end

  def handle_in("this_year_sales", payload, socket) do
    # broadcast(socket, "shout", payload)
    IO.inspect(payload["date_start"])
    IO.inspect(payload["date_end"])

    IO.inspect(payload)
    IO.inspect(socket)

    date = Date.from_iso8601!(payload["date_start"])

    list = Date.range(Timex.beginning_of_year(date), Timex.end_of_year(date))

    list_month = list |> Enum.map(fn x -> x.month end) |> Enum.uniq()

    date_start = Timex.beginning_of_year(date)

    date_end = Timex.end_of_year(date)

    sales =
      Repo.all(
        from(
          i in Reports.Sale,
          where: i.salesdate >= ^date_start and i.salesdate <= ^date_end,
          select: %{
            salesdate: i.salesdate,
            sales: i.grand_total
          }
        )
      )

    final =
      for item <- list_month do
        sales = sales |> Enum.filter(fn x -> x.salesdate.month == item end)

        total =
          if sales == [] do
            %{month: item, sales: 0}
          else
            sales =
              sales
              |> Enum.map(fn x -> Decimal.to_float(x.sales) end)
              |> Enum.sum()
              |> Float.round(2)

            %{month: item, sales: sales}
          end

        total
      end

    IO.inspect(final)

    broadcast(socket, "this_year_sales_reply", %{result: final})
    {:noreply, socket}
  end
end
