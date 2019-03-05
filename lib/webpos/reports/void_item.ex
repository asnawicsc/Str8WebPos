defmodule Webpos.Reports.VoidItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "void_items" do
    field(:item_name, :string)
    field(:order_id, :string)
    field(:reason, :string)
    field(:rest_id, :integer)
    field(:table_name, :string)
    field(:void_by, :string)
    field(:void_datetime, :naive_datetime)

    timestamps()
  end

  @doc false
  def changeset(void_item, attrs) do
    void_item
    |> cast(attrs, [
      :item_name,
      :void_by,
      :order_id,
      :table_name,
      :rest_id,
      :void_datetime,
      :reason
    ])
    |> validate_required([:item_name, :void_by, :order_id, :table_name, :rest_id, :void_datetime])
  end
end
