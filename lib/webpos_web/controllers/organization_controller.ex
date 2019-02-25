defmodule WebposWeb.OrganizationController do
  use WebposWeb, :controller

  alias Webpos.Settings
  alias Webpos.Settings.Organization
  require IEx

  def index(conn, _params) do
    organizations = Settings.list_organizations(conn)
    render(conn, "index.html", organizations: organizations)
  end

  def new(conn, _params) do
    changeset = Settings.change_organization(%Organization{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"organization" => organization_params}) do
    case Settings.create_organization(organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization created successfully.")
        |> redirect(to: organization_path(conn, :show, organization))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = Settings.get_organization!(id)

    # list of restaurants

    restaurants = Settings.list_restaurants(id)
    render(conn, "show.html", organization: organization, restaurants: restaurants)
  end

  def edit(conn, %{"id" => id}) do
    organization = Settings.get_organization!(id)
    changeset = Settings.change_organization(organization)
    render(conn, "edit.html", organization: organization, changeset: changeset)
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = Settings.get_organization!(id)

    user_name = conn.private.plug_session["user_name"]
    user_type = conn.private.plug_session["user_type"]
    org_id = conn.private.plug_session["org_id"]

    log_before =
      organization |> Map.from_struct() |> Map.drop([:__meta__, :__struct__]) |> Poison.encode!()

    case Settings.update_organization(organization, organization_params) do
      {:ok, organization} ->
        log_after =
          organization
          |> Map.from_struct()
          |> Map.drop([:__meta__, :__struct__])
          |> Poison.encode!()

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
          primary_id: organization.id,
          changes: fullsec,
          organization_id: org_id
        }

        Reports.create_modal_lllog(modal_log_params)

        conn
        |> put_flash(:info, "Organization updated successfully.")
        |> redirect(to: organization_path(conn, :show, organization))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", organization: organization, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Settings.get_organization!(id)
    {:ok, _organization} = Settings.delete_organization(organization)

    conn
    |> put_flash(:info, "Organization deleted successfully.")
    |> redirect(to: organization_path(conn, :index))
  end
end
