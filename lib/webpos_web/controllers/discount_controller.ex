defmodule WebposWeb.DiscountController do
  use WebposWeb, :controller

  alias Webpos.Menu
  alias Webpos.Menu.Discount
  require IEx

  def index(conn, _params) do
    organization_id = Settings.get_org_id(conn)

    discounts = Menu.list_discounts(organization_id)
    render(conn, "index.html", discounts: discounts)
  end

  def new(conn, _params) do
    changeset = Menu.change_discount(%Discount{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"discount" => discount_params}) do
    discount_params = Map.put(discount_params, "organization_id", Settings.get_org_id(conn))

    case Menu.create_discount(discount_params) do
      {:ok, discount} ->
        conn
        |> put_flash(:info, "Discount created successfully.")
        |> redirect(
          to: discount_path(conn, :index, Base.url_encode64(Settings.get_org_name(conn)))
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    discount = Menu.get_discount!(id)
    render(conn, "show.html", discount: discount)
  end

  def edit(conn, %{"id" => id}) do
    discount = Menu.get_discount!(id)
    changeset = Menu.change_discount(discount)
    render(conn, "edit.html", discount: discount, changeset: changeset)
  end

  def update(conn, %{"id" => id, "discount" => discount_params}) do
    discount = Menu.get_discount!(id)
    discount_params = Map.put(discount_params, "organization_id", Settings.get_org_id(conn))

    user_name = conn.private.plug_session["user_name"]
    user_type = conn.private.plug_session["user_type"]
    org_id = conn.private.plug_session["org_id"]

    log_before =
      discount |> Map.from_struct() |> Map.drop([:__meta__, :__struct__]) |> Poison.encode!()

    case Menu.update_discount(discount, discount_params) do
      {:ok, discount} ->
        log_after =
          discount |> Map.from_struct() |> Map.drop([:__meta__, :__struct__]) |> Poison.encode!()

        a = log_before |> Poison.decode!() |> Enum.map(fn x -> x end)
        b = log_after |> Poison.decode!() |> Enum.map(fn x -> x end)
        bef = a -- b
        aft = b -- a

        fullsec =
          for item <- aft |> Enum.filter(fn x -> x |> elem(0) != "updated_at" end) do
            data = item |> elem(0)
            data2 = item |> elem(1)

            bef = bef |> Enum.filter(fn x -> x |> elem(0) == data end) |> hd

            full_bef = bef |> elem(1)

            fullsec = data <> ": change " <> full_bef <> " to " <> data2
            fullsec
          end
          |> Poison.encode!()

        datetime = Timex.now() |> DateTime.to_naive()

        modal_log_params = %{
          user_name: user_name,
          user_type: user_type,
          before_change: log_before,
          after_change: log_after,
          datetime: datetime,
          category: conn.path_info |> hd,
          primary_id: discount.id,
          changes: fullsec,
          organization_id: org_id
        }

        Reports.create_modal_lllog(modal_log_params)

        conn
        |> put_flash(:info, "Discount updated successfully.")
        |> redirect(to: discount_path(conn, :index, Settings.get_org_name_encoded(conn)))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", discount: discount, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    discount = Menu.get_discount!(id)
    {:ok, _discount} = Menu.delete_discount(discount)

    conn
    |> put_flash(:info, "Discount deleted successfully.")
    |> redirect(to: discount_path(conn, :index))
  end

  def toggle_discount(conn, params) do
    rest = Repo.get_by(Restaurant, code: params["code"])

    result =
      Repo.all(
        from(
          r in RestDiscount,
          where: r.rest_id == ^rest.id and r.discount_id == ^params["discount_id"]
        )
      )

    if params["check"] == "true" do
      discount =
        if result == [] do
          # need to create
          {:ok, discount} =
            RestDiscount.changeset(%RestDiscount{}, %{
              rest_id: rest.id,
              discount_id: params["discount_id"]
            })
            |> Repo.insert()

          discount
        else
        end
    else
      d = result |> hd()

      Repo.delete(d)
    end

    json_map = [%{stats: "ok"}] |> Poison.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json_map)
  end

  def check_discount(conn, params) do
    rest = Repo.get_by(Restaurant, code: params["code"])

    result =
      Repo.all(
        from(
          r in RestDiscount,
          where: r.rest_id == ^rest.id and r.discount_id == ^params["discount_id"]
        )
      )

    json_map =
      if result == [] do
        [%{stats: "none"}] |> Poison.encode!()
      else
        [%{stats: "ok"}] |> Poison.encode!()
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json_map)
  end
end
