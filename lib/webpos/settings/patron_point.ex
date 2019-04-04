defmodule Webpos.Settings.PatronPoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "patron_points" do
    field(:accumulated, :integer, default: 0)
    field(:in, :integer, default: 0)
    field(:out, :integer, default: 0)
    field(:patron_id, :integer)
    field(:remarks, :string)
    field(:salesdate, :date)
    field(:salesid, :string)

    timestamps()
  end

  @doc false
  def changeset(patron_point, attrs) do
    patron_point
    |> cast(attrs, [:in, :out, :remarks, :patron_id, :accumulated, :salesdate, :salesid])
    |> validate_required([:in, :out, :remarks, :patron_id, :accumulated, :salesdate, :salesid])
  end
end
