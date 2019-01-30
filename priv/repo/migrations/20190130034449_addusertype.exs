defmodule Webpos.Repo.Migrations.Addusertype do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:user_type, :string)
      add(:pin, :string)
    end
  end
end
