defmodule Webpos.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:tables) do
      add :rest_id, :integer
      add :rest_table_id, :integer
      add :name, :string
      add :pos_x, :float
      add :pos_y, :float

      timestamps()
    end

  end
end
