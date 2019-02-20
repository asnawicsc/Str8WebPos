defmodule Webpos.Settings.Restaurant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "restaurants" do
    field(:address, :string)
    field(:code, :string)
    field(:key, :string)
    field(:name, :string)
    field(:reg_id, :string)
    field(:tax_code, :string)
    field(:tax_id, :string)
    field(:tax_perc, :decimal)
    field(:serv, :decimal)
    field(:organization_id, :integer)
    field(:op_id, :integer)
    timestamps()
  end

  @doc false
  def changeset(restaurant, attrs) do
    restaurant
    |> cast(attrs, [
      :op_id,
      :organization_id,
      :tax_perc,
      :serv,
      :name,
      :code,
      :key,
      :address,
      :tax_id,
      :reg_id,
      :tax_code
    ])
    |> validate_required([:op_id, :name, :code, :key, :address, :tax_id, :reg_id, :tax_code])
    |> unique_constraint(:code, name: :org_rest_code)
  end
end
