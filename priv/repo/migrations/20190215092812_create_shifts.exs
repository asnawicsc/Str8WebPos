defmodule Webpos.Repo.Migrations.CreateShifts do
  use Ecto.Migration

  def change do
    create table(:shifts) do
      add :opening_staff, :string
      add :start_datetime, :naive_datetime
      add :open_amount, :decimal
      add :closing_staff, :string
      add :end_datetime, :naive_datetime
      add :close_amount, :decimal
      add :organization_id, :integer
      add :rest_id, :integer

      timestamps()
    end

  end
end
