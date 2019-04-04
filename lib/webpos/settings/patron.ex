defmodule Webpos.Settings.Patron do
  use Ecto.Schema
  import Ecto.Changeset

  schema "patrons" do
    field(:birthday, :string)
    field(:name, :string, default: "New Member")
    field(:phone, :string)
    field(:points, :integer, default: 0)
    field(:remarks, :binary)
    field(:rest_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(patron, attrs) do
    patron
    |> cast(attrs, [:name, :phone, :birthday, :remarks, :points, :rest_id])
    |> validate_required([:name, :phone, :rest_id])
  end
end
