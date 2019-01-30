defmodule Webpos.Repo.Migrations.CreatePricingTable do
  use Ecto.Migration

  def change do
    create table(:item_price) do
      add(:op_id, :integer)
      add(:item_id, :integer)
      add(:price, :decimal)

      timestamps()
    end

    create table(:combo_price) do
      add(:op_id, :integer)
      add(:item_id, :integer)
      add(:price, :decimal)

      timestamps()
    end
  end
end
