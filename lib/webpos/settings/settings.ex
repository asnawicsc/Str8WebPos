defmodule Webpos.Settings do
  @moduledoc """
  The Settings context.
  """
  require IEx
  import Ecto.Query, warn: false
  import Mogrify
  alias Webpos.Repo

  def image_upload(param, organization_id) do
    path = File.cwd!() <> "/media"
    image_path = Application.app_dir(:webpos, "priv/static/images")

    if File.exists?(path) == false do
      File.mkdir(File.cwd!() <> "/media")
    end

    fl = param.filename |> String.replace(" ", "_")
    absolute_path = path <> "/#{organization_id}_#{fl}"
    absolute_path_bin = path <> "/bin_" <> "#{organization_id}_#{fl}"
    File.cp(param.path, absolute_path)
    File.rm(image_path <> "/uploads")
    File.ln_s(path, image_path <> "/uploads")

    resized =
      Mogrify.open(absolute_path)
      |> resize("100x100")
      |> save(path: absolute_path_bin)

    File.cp(resized.path, absolute_path)
    File.rm(image_path <> "/uploads")
    File.ln_s(path, image_path <> "/uploads")

    {:ok, bin} = File.read(resized.path)

    File.rm(resized.path)
    "#{organization_id}_#{fl}"
  end

  alias Webpos.Settings.User

  def get_org_id(conn) do
    Repo.get(
      Webpos.Settings.Organization,
      Repo.get(User, conn.private.plug_session["user_id"]).organization_id
    ).id
  end

  def get_org_name(conn) do
    Repo.get(
      Webpos.Settings.Organization,
      Repo.get(User, conn.private.plug_session["user_id"]).organization_id
    ).name
  end

  def get_org_name_encoded(conn) do
    Repo.get(
      Webpos.Settings.Organization,
      Repo.get(User, conn.private.plug_session["user_id"]).organization_id
    ).name
    |> Base.url_encode64()
  end

  def current_user(conn) do
    Repo.get(User, conn.private.plug_session["user_id"])
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(organization_id) do
    if organization_id != nil do
      Repo.all(from(u in User, where: u.organization_id == ^organization_id))
    else
      Repo.all(User)
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Webpos.Settings.Organization

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  def list_organizations(conn) do
    if conn.private.plug_session["super_admin"] do
      Repo.all(Organization)
    else
      user = current_user(conn)
      Repo.all(from(o in Organization, where: o.id == ^user.organization_id))
    end
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the Organization does not exist.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

      iex> get_organization!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organization!(id), do: Repo.get!(Organization, id)

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{source: %Organization{}}

  """
  def change_organization(%Organization{} = organization) do
    Organization.changeset(organization, %{})
  end

  alias Webpos.Settings.Restaurant

  @doc """
  Returns the list of restaurants.

  ## Examples

      iex> list_restaurants()
      [%Restaurant{}, ...]

  """
  def list_restaurants(org_id) do
    if org_id == nil do
      Repo.all(Restaurant)
    else
      Repo.all(from(r in Restaurant, where: r.organization_id == ^org_id))
    end
  end

  @doc """
  Gets a single restaurant.

  Raises `Ecto.NoResultsError` if the Restaurant does not exist.

  ## Examples

      iex> get_restaurant!(123)
      %Restaurant{}

      iex> get_restaurant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_restaurant!(id), do: Repo.get!(Restaurant, id)

  @doc """
  Creates a restaurant.

  ## Examples

      iex> create_restaurant(%{field: value})
      {:ok, %Restaurant{}}

      iex> create_restaurant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_restaurant(attrs \\ %{}) do
    %Restaurant{}
    |> Restaurant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a restaurant.

  ## Examples

      iex> update_restaurant(restaurant, %{field: new_value})
      {:ok, %Restaurant{}}

      iex> update_restaurant(restaurant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_restaurant(%Restaurant{} = restaurant, attrs) do
    restaurant
    |> Restaurant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Restaurant.

  ## Examples

      iex> delete_restaurant(restaurant)
      {:ok, %Restaurant{}}

      iex> delete_restaurant(restaurant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_restaurant(%Restaurant{} = restaurant) do
    Repo.delete(restaurant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking restaurant changes.

  ## Examples

      iex> change_restaurant(restaurant)
      %Ecto.Changeset{source: %Restaurant{}}

  """
  def change_restaurant(%Restaurant{} = restaurant) do
    Restaurant.changeset(restaurant, %{})
  end
end