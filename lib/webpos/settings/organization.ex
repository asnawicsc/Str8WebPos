defmodule Webpos.Settings.Organization do
  use Ecto.Schema
  import Ecto.Changeset


  schema "organizations" do
    field :address, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :address])
    |> validate_required([:name, :address])
  end
end
