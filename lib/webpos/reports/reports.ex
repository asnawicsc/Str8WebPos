defmodule Webpos.Reports do
  @moduledoc """
  The Reports context.
  """
  require IEx
  import Ecto.Query, warn: false
  alias Webpos.Repo

  alias Webpos.Reports.{Sale, SalesPayment, SalesDetail}

  def list_sales_payment(startd, endd) do
    a =
      Repo.all(
        from(
          s in Sale,
          left_join: p in SalesPayment,
          on: s.salesid == p.salesid,
          where: s.salesdate >= ^startd and s.salesdate <= ^endd,
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

  @doc """
  Returns the list of sales.

  ## Examples

      iex> list_sales()
      [%Sale{}, ...]

  """
  def list_sales do
    Repo.all(Sale)
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
end
