defmodule Webpos.Repo.Migrations.CreatePatrons do
  use Ecto.Migration

  def change do
    create table(:patrons) do
      add :name, :string
      add :phone, :string
      add :birthday, :string
      add :remarks, :binary
      add :points, :integer
      add :rest_id, :integer

      timestamps()
    end

  end
end
