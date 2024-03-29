# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Webpos.Repo.insert!(%Webpos.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Webpos.Settings
alias Webpos.Settings.{User, Organization, Restaurant}
alias Webpos.Repo
import Ecto.Query
Repo.delete_all(Organization)

{:ok, org} = Settings.create_organization(%{address: "Serdang", name: "Resertech"})
Repo.delete_all(User)

{:ok, user} =
  Settings.create_user(%{
    username: "admin",
    crypted_password: Comeonin.Bcrypt.hashpwsalt("123"),
    organization_id: org.id
  })
