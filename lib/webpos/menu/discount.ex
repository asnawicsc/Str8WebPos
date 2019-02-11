defmodule Webpos.Menu.Discount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "discounts" do
    field(:amount, :float)
    field(:category, :string)
    field(:description, :string)
    field(:disc_type, :string)
    field(:name, :string)
    field(:requirements, :binary)
    field(:targets, :binary)
    field(:organization_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(discount, attrs) do
    discount
    |> cast(attrs, [
      :organization_id,
      :name,
      :description,
      :category,
      :disc_type,
      :amount,
      :requirements,
      :targets
    ])
    |> validate_required([:name, :description, :category, :disc_type, :amount, :organization_id])
  end
end

defmodule Webpos.Menu.RestDiscount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rest_discounts" do
    field(:rest_id, :integer)
    field(:discount_id, :integer)
  end

  @doc false
  def changeset(discount, attrs) do
    discount
    |> cast(attrs, [
      :rest_id,
      :discount_id
    ])
    |> validate_required([:rest_id, :discount_id])
  end
end
