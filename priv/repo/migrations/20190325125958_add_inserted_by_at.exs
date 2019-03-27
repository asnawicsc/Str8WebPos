defmodule Webpos.Repo.Migrations.AddInsertedByAt do
  use Ecto.Migration

  def change do
    alter table("sales_details") do
      add(:inserted_by, :string)
      add(:inserted_time, :naive_datetime)
    end
  end
end
