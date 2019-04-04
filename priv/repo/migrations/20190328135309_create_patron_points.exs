defmodule Webpos.Repo.Migrations.CreatePatronPoints do
  use Ecto.Migration

  def change do
    create table(:patron_points) do
      add :in, :integer
      add :out, :integer
      add :remarks, :string
      add :patron_id, :integer
      add :accumulated, :integer
      add :salesdate, :date
      add :salesid, :string

      timestamps()
    end

  end
end
