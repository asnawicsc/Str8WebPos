defmodule Webpos.Menu do
  @moduledoc """
  The Menu context.
  """

  import Ecto.Query, warn: false
  alias Webpos.Repo

  alias Webpos.Menu.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items(organization_id) do
    if organization_id == nil do
      Repo.all(Item)
    else
      Repo.all(from(i in Item, where: i.organization_id == ^organization_id))
    end
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{source: %Item{}}

  """
  def change_item(%Item{} = item) do
    Item.changeset(item, %{})
  end

  alias Webpos.Menu.Combo

  @doc """
  Returns the list of combos.

  ## Examples

      iex> list_combos()
      [%Combo{}, ...]

  """
  def list_combos do
    Repo.all(Combo)
  end

  @doc """
  Gets a single combo.

  Raises `Ecto.NoResultsError` if the Combo does not exist.

  ## Examples

      iex> get_combo!(123)
      %Combo{}

      iex> get_combo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_combo!(id), do: Repo.get!(Combo, id)

  @doc """
  Creates a combo.

  ## Examples

      iex> create_combo(%{field: value})
      {:ok, %Combo{}}

      iex> create_combo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_combo(attrs \\ %{}) do
    %Combo{}
    |> Combo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a combo.

  ## Examples

      iex> update_combo(combo, %{field: new_value})
      {:ok, %Combo{}}

      iex> update_combo(combo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_combo(%Combo{} = combo, attrs) do
    combo
    |> Combo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Combo.

  ## Examples

      iex> delete_combo(combo)
      {:ok, %Combo{}}

      iex> delete_combo(combo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_combo(%Combo{} = combo) do
    Repo.delete(combo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking combo changes.

  ## Examples

      iex> change_combo(combo)
      %Ecto.Changeset{source: %Combo{}}

  """
  def change_combo(%Combo{} = combo) do
    Combo.changeset(combo, %{})
  end
end
