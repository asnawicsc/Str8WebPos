defmodule Webpos.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :address, :string

      timestamps()
    end

  end
end
