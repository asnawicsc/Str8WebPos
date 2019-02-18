defmodule Webpos.Reports do
  @moduledoc """
  The Reports context.
  """
  require IEx
  import Ecto.Query, warn: false
  alias Webpos.Repo

  alias Webpos.Reports.{Sale, SalesPayment, SalesDetail}

  def list_sales_payment(startd, endd, rest_name) do
    a =
      Repo.all(
        from(
          s in Sale,
          left_join: p in SalesPayment,
          on: s.salesid == p.salesid,
          where: s.salesdate >= ^startd and s.salesdate <= ^endd and s.rest_name == ^rest_name,
          select: %{
            st: sum(p.sub_total),
            tax: sum(p.gst_charge),
            serv: sum(p.service_charge),
            round: sum(p.rounding),
            gt: sum(p.grand_total),
            cash: sum(p.cash),
            changes: sum(p.changes)
          }
        )
      )
      |> Enum.map(fn x ->
        Map.put(
          x,
          :changes,
          Decimal.round(if(x.changes != nil, do: x.changes, else: Decimal.new(0)), 2)
        )
      end)

    a
  end

  def list_sales_details(startd, endd, rest_name) do
    a =
      Repo.all(
        from(
          s in Sale,
          left_join: p in SalesDetail,
          on: s.salesid == p.salesid,
          where: s.salesdate >= ^startd and s.salesdate <= ^endd and s.rest_name == ^rest_name,
          select: %{
            salesdate: s.salesdate,
            branch: s.rest_name,
            itemname: p.itemname,
            unit_price: p.unit_price,
            sub_total: p.sub_total,
            qty: p.qty
          }
        )
      )

    a
  end

  @doc """
  Returns the list of sales.

  ## Examples

      iex> list_sales()
      [%Sale{}, ...]

  """
  def list_sales(organization_id) do
    if organization_id != nil do
      Repo.all(from(s in Sale, where: s.organization_id == ^organization_id))
    else
      Repo.all(Sale)
    end
  end

  @doc """
  Gets a single sale.

  Raises `Ecto.NoResultsError` if the Sale does not exist.

  ## Examples

      iex> get_sale!(123)
      %Sale{}

      iex> get_sale!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sale!(id), do: Repo.get!(Sale, id)

  @doc """
  Creates a sale.

  ## Examples

      iex> create_sale(%{field: value})
      {:ok, %Sale{}}

      iex> create_sale(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sale(attrs \\ %{}) do
    %Sale{}
    |> Sale.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sale.

  ## Examples

      iex> update_sale(sale, %{field: new_value})
      {:ok, %Sale{}}

      iex> update_sale(sale, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sale(%Sale{} = sale, attrs) do
    sale
    |> Sale.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Sale.

  ## Examples

      iex> delete_sale(sale)
      {:ok, %Sale{}}

      iex> delete_sale(sale)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sale(%Sale{} = sale) do
    Repo.delete(sale)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sale changes.

  ## Examples

      iex> change_sale(sale)
      %Ecto.Changeset{source: %Sale{}}

  """
  def change_sale(%Sale{} = sale) do
    Sale.changeset(sale, %{})
  end

  alias Webpos.Reports.Shift

  @doc """
  Returns the list of shifts.

  ## Examples

      iex> list_shifts()
      [%Shift{}, ...]

  """
  def list_shifts do
    Repo.all(Shift)
  end

  @doc """
  Gets a single shift.

  Raises `Ecto.NoResultsError` if the Shift does not exist.

  ## Examples

      iex> get_shift!(123)
      %Shift{}

      iex> get_shift!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shift!(id), do: Repo.get!(Shift, id)

  @doc """
  Creates a shift.

  ## Examples

      iex> create_shift(%{field: value})
      {:ok, %Shift{}}

      iex> create_shift(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shift(attrs \\ %{}) do
    %Shift{}
    |> Shift.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shift.

  ## Examples

      iex> update_shift(shift, %{field: new_value})
      {:ok, %Shift{}}

      iex> update_shift(shift, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shift(%Shift{} = shift, attrs) do
    shift
    |> Shift.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Shift.

  ## Examples

      iex> delete_shift(shift)
      {:ok, %Shift{}}

      iex> delete_shift(shift)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shift(%Shift{} = shift) do
    Repo.delete(shift)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shift changes.

  ## Examples

      iex> change_shift(shift)
      %Ecto.Changeset{source: %Shift{}}

  """
  def change_shift(%Shift{} = shift) do
    Shift.changeset(shift, %{})
  end
end
