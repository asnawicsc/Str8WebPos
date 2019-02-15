defmodule Webpos.Reports.Shift do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shifts" do
    field(:close_amount, :decimal)
    field(:closing_staff, :string)
    field(:end_datetime, :naive_datetime)
    field(:open_amount, :decimal)
    field(:opening_staff, :string)
    field(:organization_id, :integer)
    field(:rest_id, :integer)
    field(:start_datetime, :naive_datetime)

    timestamps()
  end

  @doc false
  def changeset(shift, attrs) do
    shift
    |> cast(attrs, [
      :opening_staff,
      :start_datetime,
      :open_amount,
      :closing_staff,
      :end_datetime,
      :close_amount,
      :organization_id,
      :rest_id
    ])
    |> validate_required([:opening_staff, :start_datetime, :organization_id, :rest_id])
  end
end
