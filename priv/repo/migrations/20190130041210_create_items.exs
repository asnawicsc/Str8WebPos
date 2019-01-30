defmodule Webpos.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :img_url, :string
      add :code, :string
      add :desc, :string
      add :customizations, :binary

      timestamps()
    end

  end
end
