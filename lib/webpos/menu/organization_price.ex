defmodule Webpos.Menu.OrganizationPrice do
  use Ecto.Schema
  import Ecto.Changeset


  schema "organization_price" do
    field :name, :string
    field :organization_id, :integer

    timestamps()
  end

  @doc false
  def changeset(organization_price, attrs) do
    organization_price
    |> cast(attrs, [:organization_id, :name])
    |> validate_required([:organization_id, :name])
  end
end
