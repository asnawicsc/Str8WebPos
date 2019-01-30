defmodule Webpos.Menu.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field(:code, :string)
    field(:customizations, :binary)
    field(:desc, :string)
    field(:img_url, :string)
    field(:name, :string)
    field(:category, :string)
    field(:is_combo, :boolean)
    field(:organization_id, :integer)
    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [
      :organization_id,
      :is_combo,
      :category,
      :name,
      :img_url,
      :code,
      :desc,
      :customizations
    ])
    |> validate_required([:name, :code, :desc])
  end
end
