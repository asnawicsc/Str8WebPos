defmodule Webpos.Menu.Combo do
  use Ecto.Schema
  import Ecto.Changeset


  schema "combos" do
    field :category, :string
    field :category_limit, :integer
    field :combo_id, :integer
    field :item_id, :integer

    timestamps()
  end

  @doc false
  def changeset(combo, attrs) do
    combo
    |> cast(attrs, [:combo_id, :item_id, :category, :category_limit])
    |> validate_required([:combo_id, :item_id, :category, :category_limit])
  end
end
