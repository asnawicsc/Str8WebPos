defmodule Webpos.Repo.Migrations.CreateModallogs do
  use Ecto.Migration

  def change do
    create table(:modallogs) do
      add :user_name, :string
      add :user_type, :string
      add :before_change, :string
      add :after_change, :string
      add :datetime, :naive_datetime
      add :category, :string
      add :primary_id, :integer

      timestamps()
    end

  end
end
