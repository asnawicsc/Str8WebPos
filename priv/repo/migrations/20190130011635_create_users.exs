defmodule Webpos.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :crypted_password, :string
      add :email, :string

      timestamps()
    end

  end
end
