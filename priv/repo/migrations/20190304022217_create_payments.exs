defmodule Webpos.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :name, :string
      add :description, :string
      add :regex, :string

      timestamps()
    end

  end
end
