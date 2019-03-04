defmodule Webpos.Settings.Payment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "payments" do
    field :description, :string
    field :name, :string
    field :regex, :string

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:name, :description, :regex])
    |> validate_required([:name, :description, :regex])
  end
end
