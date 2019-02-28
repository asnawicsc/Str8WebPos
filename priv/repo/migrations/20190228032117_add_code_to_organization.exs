defmodule Webpos.Repo.Migrations.AddCodeToOrganization do
  use Ecto.Migration

  def change do
    alter table("organizations") do
      add(:code, :string)
    end
  end
end
