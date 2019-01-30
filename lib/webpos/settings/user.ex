defmodule Webpos.Settings.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:crypted_password, :string)
    field(:email, :string)
    field(:password, :string)
    field(:username, :string)
    field(:user_type, :string)
    field(:pin, :string)
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_type, :pin, :username, :password, :crypted_password, :email])
    |> validate_required([:username, :crypted_password])
  end
end
