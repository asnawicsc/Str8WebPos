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

  alias Webpos.Menu.OrganizationPrice

  @doc """
  Returns the list of organization_price.

  ## Examples

      iex> list_organization_price()
      [%OrganizationPrice{}, ...]

  """
  def list_organization_price do
    Repo.all(OrganizationPrice)
  end

  @doc """
  Gets a single organization_price.

  Raises `Ecto.NoResultsError` if the Organization price does not exist.

  ## Examples

      iex> get_organization_price!(123)
      %OrganizationPrice{}

      iex> get_organization_price!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organization_price!(id), do: Repo.get!(OrganizationPrice, id)

  @doc """
  Creates a organization_price.

  ## Examples

      iex> create_organization_price(%{field: value})
      {:ok, %OrganizationPrice{}}

      iex> create_organization_price(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization_price(attrs \\ %{}) do
    %OrganizationPrice{}
    |> OrganizationPrice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization_price.

  ## Examples

      iex> update_organization_price(organization_price, %{field: new_value})
      {:ok, %OrganizationPrice{}}

      iex> update_organization_price(organization_price, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization_price(%OrganizationPrice{} = organization_price, attrs) do
    organization_price
    |> OrganizationPrice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OrganizationPrice.

  ## Examples

      iex> delete_organization_price(organization_price)
      {:ok, %OrganizationPrice{}}

      iex> delete_organization_price(organization_price)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization_price(%OrganizationPrice{} = organization_price) do
    Repo.delete(organization_price)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization_price changes.

  ## Examples

      iex> change_organization_price(organization_price)
      %Ecto.Changeset{source: %OrganizationPrice{}}

  """
  def change_organization_price(%OrganizationPrice{} = organization_price) do
    OrganizationPrice.changeset(organization_price, %{})
  end

  alias Webpos.Menu.Printer

  @doc """
  Returns the list of printers.

  ## Examples

      iex> list_printers()
      [%Printer{}, ...]

  """
  def list_printers(organization_id) do
    Repo.all(from(p in Printer, where: p.organization_id == ^organization_id))
  end

  @doc """
  Gets a single printer.

  Raises `Ecto.NoResultsError` if the Printer does not exist.

  ## Examples

      iex> get_printer!(123)
      %Printer{}

      iex> get_printer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_printer!(id), do: Repo.get!(Printer, id)

  @doc """
  Creates a printer.

  ## Examples

      iex> create_printer(%{field: value})
      {:ok, %Printer{}}

      iex> create_printer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_printer(attrs \\ %{}) do
    %Printer{}
    |> Printer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a printer.

  ## Examples

      iex> update_printer(printer, %{field: new_value})
      {:ok, %Printer{}}

      iex> update_printer(printer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_printer(%Printer{} = printer, attrs) do
    printer
    |> Printer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Printer.

  ## Examples

      iex> delete_printer(printer)
      {:ok, %Printer{}}

      iex> delete_printer(printer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_printer(%Printer{} = printer) do
    Repo.delete(printer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking printer changes.

  ## Examples

      iex> change_printer(printer)
      %Ecto.Changeset{source: %Printer{}}

  """
  def change_printer(%Printer{} = printer) do
    Printer.changeset(printer, %{})
  end

  alias Webpos.Menu.Discount

  @doc """
  Returns the list of discounts.

  ## Examples

      iex> list_discounts()
      [%Discount{}, ...]

  """
  def list_discounts do
    Repo.all(Discount)
  end

  @doc """
  Gets a single discount.

  Raises `Ecto.NoResultsError` if the Discount does not exist.

  ## Examples

      iex> get_discount!(123)
      %Discount{}

      iex> get_discount!(456)
      ** (Ecto.NoResultsError)

  """
  def get_discount!(id), do: Repo.get!(Discount, id)

  @doc """
  Creates a discount.

  ## Examples

      iex> create_discount(%{field: value})
      {:ok, %Discount{}}

      iex> create_discount(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_discount(attrs \\ %{}) do
    %Discount{}
    |> Discount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a discount.

  ## Examples

      iex> update_discount(discount, %{field: new_value})
      {:ok, %Discount{}}

      iex> update_discount(discount, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_discount(%Discount{} = discount, attrs) do
    discount
    |> Discount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Discount.

  ## Examples

      iex> delete_discount(discount)
      {:ok, %Discount{}}

      iex> delete_discount(discount)
      {:error, %Ecto.Changeset{}}

  """
  def delete_discount(%Discount{} = discount) do
    Repo.delete(discount)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking discount changes.

  ## Examples

      iex> change_discount(discount)
      %Ecto.Changeset{source: %Discount{}}

  """
  def change_discount(%Discount{} = discount) do
    Discount.changeset(discount, %{})
  end
end
