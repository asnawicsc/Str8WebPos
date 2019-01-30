defmodule Webpos.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants) do
      add :name, :string
      add :code, :string
      add :key, :string
      add :address, :string
      add :tax_id, :string
      add :reg_id, :string
      add :tax_code, :string

      timestamps()
    end

  end
end
