defmodule Webpos.Settings.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field(:address, :string)
    field(:name, :string)
    field(:categories, :string)
    field(:payments, :string)
    field(:code, :string)
    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:categories, :payments, :name, :address, :code])
    |> validate_required([:name, :address])
  end
end

defmodule Webpos.Menu.ItemPrice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_price" do
    field(:op_id, :integer)
    field(:item_id, :integer)
    field(:price, :decimal)
    timestamps()
  end

  @doc false
  def changeset(organization_price, attrs) do
    organization_price
    |> cast(attrs, [
      :op_id,
      :item_id,
      :price
    ])
    |> validate_required([:op_id, :item_id, :price])
  end
end

defmodule Webpos.Menu.ComboPrice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "combo_price" do
    field(:op_id, :integer)
    field(:combo_id, :integer)
    field(:item_id, :integer)
    field(:price, :decimal)
    timestamps()
  end

  @doc false
  def changeset(organization_price, attrs) do
    organization_price
    |> cast(attrs, [
      :combo_id,
      :op_id,
      :item_id,
      :price
    ])
    |> validate_required([:combo_id, :op_id, :item_id, :price])
  end
end
