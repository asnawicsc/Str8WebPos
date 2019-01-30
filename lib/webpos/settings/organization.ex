defmodule Webpos.Settings.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field(:address, :string)
    field(:name, :string)
    field(:categories, :string)
    field(:payments, :string)
    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:categories, :payments, :name, :address])
    |> validate_required([:name, :address])
  end
end
