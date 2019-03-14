defmodule Webpos.Repo.Migrations.AddUuidToSales do
  use Ecto.Migration

  def change do
    alter table("sales") do
      add(:uuid, :string)
      add(:device_name, :string)
    end

    create(index(:sales, [:invoiceno]))

    create(index(:sales, [:invoiceno, :rest_name], unique: true))
  end
end
