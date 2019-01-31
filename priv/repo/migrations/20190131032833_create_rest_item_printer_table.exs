defmodule Webpos.Repo.Migrations.CreateRestItemPrinterTable do
  use Ecto.Migration

  def change do
    create table(:rest_item_printer) do
      add(:rest_id, :integer)
      add(:item_id, :integer)
      add(:printer_id, :integer)

      timestamps()
    end
  end
end
