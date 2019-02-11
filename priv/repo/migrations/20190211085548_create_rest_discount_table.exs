defmodule Webpos.Repo.Migrations.CreateRestDiscountTable do
  use Ecto.Migration

  def change do
    create table(:rest_discounts) do
      add(:rest_id, :integer)
      add(:discount_id, :integer)
    end
  end
end
