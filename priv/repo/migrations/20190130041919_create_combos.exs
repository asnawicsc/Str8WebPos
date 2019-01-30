defmodule Webpos.Repo.Migrations.CreateCombos do
  use Ecto.Migration

  def change do
    create table(:combos) do
      add :combo_id, :integer
      add :item_id, :integer
      add :category, :string
      add :category_limit, :integer

      timestamps()
    end

  end
end
