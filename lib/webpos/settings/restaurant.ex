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
    timestamps()
  end

  @doc false
  def changeset(restaurant, attrs) do
    restaurant
    |> cast(attrs, [:tax_perc, :serv, :name, :code, :key, :address, :tax_id, :reg_id, :tax_code])
    |> validate_required([:name, :code, :key, :address, :tax_id, :reg_id, :tax_code])
  end
end
