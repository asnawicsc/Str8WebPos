defmodule Webpos.Settings.Table do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tables" do
    field :name, :string
    field :pos_x, :float
    field :pos_y, :float
    field :rest_id, :integer
    field :rest_table_id, :integer

    timestamps()
  end

  @doc false
  def changeset(table, attrs) do
    table
    |> cast(attrs, [:rest_id, :rest_table_id, :name, :pos_x, :pos_y])
    |> validate_required([:rest_id, :rest_table_id, :name, :pos_x, :pos_y])
  end
end
