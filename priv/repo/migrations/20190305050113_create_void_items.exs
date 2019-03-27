defmodule Webpos.Repo.Migrations.CreateVoidItems do
  use Ecto.Migration

  def change do
    create table(:void_items) do
      add :item_name, :string
      add :void_by, :string
      add :order_id, :string
      add :table_name, :string
      add :rest_id, :string
      add :void_datetime, :naive_datetime
      add :reason, :string

      timestamps()
    end

  end
end
