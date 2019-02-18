defmodule Webpos.Settings.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:crypted_password, :string)
    field(:email, :string)
    field(:password, :string)
    field(:username, :string)
    field(:user_type, :string)
    field(:user_level, :string, default: "Cashier")
    field(:pin, :string)
    field(:organization_id, :integer)
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :user_level,
      :organization_id,
      :user_type,
      :pin,
      :username,
      :password,
      :crypted_password,
      :email
    ])
    |> validate_required([:organization_id, :username, :crypted_password])
  end
end
