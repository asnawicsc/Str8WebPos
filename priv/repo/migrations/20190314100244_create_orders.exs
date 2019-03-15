defmodule Webpos.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :rest_id, :integer
      add :organization_id, :integer
      add :order_id, :integer
      add :salesdate, :date
      add :salesdatetime, :naive_datetime
      add :table_id, :integer
      add :items, :binary

      timestamps()
    end

  end
end
