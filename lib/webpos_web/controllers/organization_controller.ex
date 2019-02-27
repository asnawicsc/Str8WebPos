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

    log_before =
      organization |> Map.from_struct() |> Map.drop([:__meta__, :__struct__]) |> Poison.encode!()

    case Settings.update_organization(organization, organization_params) do
      {:ok, organization} ->
        log_after =
          organization
          |> Map.from_struct()
          |> Map.drop([:__meta__, :__struct__])
          |> Poison.encode!()

        Settings.modal_log_create(conn, log_before, log_after, organization)

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
