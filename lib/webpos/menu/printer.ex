defmodule Webpos.Menu.Printer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "printers" do
    field(:ip_address, :string)
    field(:name, :string)
    field(:organization_id, :integer)
    field(:port_no, :string)

    timestamps()
  end

  @doc false
  def changeset(printer, attrs) do
    printer
    |> cast(attrs, [:name, :ip_address, :port_no, :organization_id])
    |> validate_required([:name, :ip_address, :port_no, :organization_id])
  end
end

defmodule Webpos.Menu.RestItemPrinter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rest_item_printer" do
    field(:rest_id, :integer)
    field(:item_id, :integer)
    field(:printer_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(obj, attrs) do
    obj
    |> cast(attrs, [:rest_id, :item_id, :printer_id])
    |> validate_required([:rest_id, :printer_id])
  end
end
