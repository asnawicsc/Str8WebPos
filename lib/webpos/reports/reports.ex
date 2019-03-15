defmodule Webpos.Reports do
  @moduledoc """
  The Reports context.
  """
  require IEx
  import Ecto.Query, warn: false
  alias Webpos.Repo

  alias Webpos.Reports.{Sale, SalesPayment, SalesDetail, Order}

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

  alias Webpos.Reports.ModalLllog

  @doc """
  Returns the list of modallogs.

  ## Examples

      iex> list_modallogs()
      [%ModalLllog{}, ...]

  """
  def list_modallogs do
    Repo.all(ModalLllog)
  end

  @doc """
  Gets a single modal_lllog.

  Raises `Ecto.NoResultsError` if the Modal lllog does not exist.

  ## Examples

      iex> get_modal_lllog!(123)
      %ModalLllog{}

      iex> get_modal_lllog!(456)
      ** (Ecto.NoResultsError)

  """
  def get_modal_lllog!(id), do: Repo.get!(ModalLllog, id)

  @doc """
  Creates a modal_lllog.

  ## Examples

      iex> create_modal_lllog(%{field: value})
      {:ok, %ModalLllog{}}

      iex> create_modal_lllog(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_modal_lllog(attrs \\ %{}) do
    %ModalLllog{}
    |> ModalLllog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a modal_lllog.

  ## Examples

      iex> update_modal_lllog(modal_lllog, %{field: new_value})
      {:ok, %ModalLllog{}}

      iex> update_modal_lllog(modal_lllog, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_modal_lllog(%ModalLllog{} = modal_lllog, attrs) do
    modal_lllog
    |> ModalLllog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ModalLllog.

  ## Examples

      iex> delete_modal_lllog(modal_lllog)
      {:ok, %ModalLllog{}}

      iex> delete_modal_lllog(modal_lllog)
      {:error, %Ecto.Changeset{}}

  """
  def delete_modal_lllog(%ModalLllog{} = modal_lllog) do
    Repo.delete(modal_lllog)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking modal_lllog changes.

  ## Examples

      iex> change_modal_lllog(modal_lllog)
      %Ecto.Changeset{source: %ModalLllog{}}

  """
  def change_modal_lllog(%ModalLllog{} = modal_lllog) do
    ModalLllog.changeset(modal_lllog, %{})
  end

  alias Webpos.Reports.VoidItem

  @doc """
  Returns the list of void_items.

  ## Examples

      iex> list_void_items()
      [%VoidItem{}, ...]

  """
  def list_void_items do
    Repo.all(VoidItem)
  end

  @doc """
  Gets a single void_item.

  Raises `Ecto.NoResultsError` if the Void item does not exist.

  ## Examples

      iex> get_void_item!(123)
      %VoidItem{}

      iex> get_void_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_void_item!(id), do: Repo.get!(VoidItem, id)

  @doc """
  Creates a void_item.

  ## Examples

      iex> create_void_item(%{field: value})
      {:ok, %VoidItem{}}

      iex> create_void_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_void_item(attrs \\ %{}) do
    %VoidItem{}
    |> VoidItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a void_item.

  ## Examples

      iex> update_void_item(void_item, %{field: new_value})
      {:ok, %VoidItem{}}

      iex> update_void_item(void_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_void_item(%VoidItem{} = void_item, attrs) do
    void_item
    |> VoidItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a VoidItem.

  ## Examples

      iex> delete_void_item(void_item)
      {:ok, %VoidItem{}}

      iex> delete_void_item(void_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_void_item(%VoidItem{} = void_item) do
    Repo.delete(void_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking void_item changes.

  ## Examples

      iex> change_void_item(void_item)
      %Ecto.Changeset{source: %VoidItem{}}

  """
  def change_void_item(%VoidItem{} = void_item) do
    VoidItem.changeset(void_item, %{})
  end

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Order{} = order) do
    Order.changeset(order, %{})
  end
end
