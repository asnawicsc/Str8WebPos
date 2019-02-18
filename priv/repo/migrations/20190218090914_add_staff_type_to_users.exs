defmodule Webpos.Repo.Migrations.AddStaffTypeToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:user_level, :string, default: "Cashier")
    end
  end
end
