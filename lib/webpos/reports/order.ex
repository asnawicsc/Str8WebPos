defmodule Webpos.Reports.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:items, :binary)
    field(:order_id, :integer)
    field(:organization_id, :integer)
    field(:rest_id, :integer)
    field(:salesdate, :date)
    field(:salesdatetime, :naive_datetime)
    field(:table_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :rest_id,
      :organization_id,
      :order_id,
      :salesdate,
      :salesdatetime,
      :table_id,
      :items
    ])
    |> validate_required([
      :rest_id,
      :organization_id,
      :order_id,
      :salesdate,
      :salesdatetime,
      :table_id,
      :items
    ])
  end
end
