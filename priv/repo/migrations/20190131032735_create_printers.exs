defmodule Webpos.Repo.Migrations.CreatePrinters do
  use Ecto.Migration

  def change do
    create table(:printers) do
      add :name, :string
      add :ip_address, :string
      add :port_no, :string
      add :organization_id, :integer

      timestamps()
    end

  end
end
