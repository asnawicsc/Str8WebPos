defmodule Webpos.Reports.ModalLllog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "modallogs" do
    field(:after_change, :string)
    field(:before_change, :string)
    field(:changes, :string)
    field(:category, :string)
    field(:datetime, :naive_datetime)
    field(:primary_id, :integer)
    field(:user_name, :string)
    field(:user_type, :string)
    field(:organization_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(modal_lllog, attrs) do
    modal_lllog
    |> cast(attrs, [
      :user_name,
      :user_type,
      :before_change,
      :after_change,
      :datetime,
      :category,
      :primary_id,
      :changes,
      :organization_id
    ])
    |> validate_required([
      :user_name,
      :user_type,
      :before_change,
      :after_change,
      :datetime,
      :category,
      :primary_id,
      :changes,
      :organization_id
    ])
  end
end
