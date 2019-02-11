defmodule Webpos.Repo.Migrations.CreateDiscounts do
  use Ecto.Migration

  def change do
    create table(:discounts) do
      add :name, :string
      add :description, :string
      add :category, :string
      add :disc_type, :string
      add :amount, :float
      add :requirements, :binary
      add :targets, :binary

      timestamps()
    end

  end
end
