defmodule WebposWeb.UserController do
  use WebposWeb, :controller

  alias Webpos.Settings
  alias Webpos.Settings.User
  require IEx

  def index(conn, params) do
    users =
      if params["q"] != nil do
        Repo.all(from(u in User, where: u.user_type == "Staff"))
      else
        Settings.list_users()
      end

    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Settings.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    user_params = Map.put(user_params, "organization_id", Settings.get_org_id(conn))

    user_params =
      if user_params["password"] != nil do
        Map.put(
          user_params,
          "crypted_password",
          Comeonin.Bcrypt.hashpwsalt(user_params["password"])
        )
        |> Map.put("password", nil)
      end

    case Settings.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Settings.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Settings.get_user!(id)
    changeset = Settings.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Settings.get_user!(id)
    user_params = Map.put(user_params, "organization_id", Settings.get_org_id(conn))

    user_params =
      if user_params["password"] != nil do
        Map.put(
          user_params,
          "crypted_password",
          Comeonin.Bcrypt.hashpwsalt(user_params["password"])
        )
        |> Map.put("password", nil)
      end

    case Settings.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Settings.get_user!(id)
    {:ok, _user} = Settings.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def login(conn, _params) do
    render(conn, "login.html", layout: {WebposWeb.LayoutView, "full_bg.html"})
  end

  def authenticate_login(conn, %{"name" => name, "password" => password}) do
    user = Repo.get_by(User, username: name)
    org = Repo.get(Organization, user.organization_id)
    org_name = Base.url_encode64(org.name)

    if user != nil do
      if Comeonin.Bcrypt.checkpw(password, user.crypted_password) do
        conn
        |> put_flash(:info, "Welcome!")
        |> put_session(:user_id, user.id)
        |> put_session(:org_name, org_name)
        |> redirect(to: page_path(conn, :index))
      else
        conn
        |> put_flash(:error, "Wrong password!")
        |> redirect(to: user_path(conn, :login))
      end
    else
      conn
      |> put_flash(:error, "User not found")
      |> redirect(to: user_path(conn, :login))
    end
  end

  # def forget_password(conn, params) do
  #   render(conn, "forget_password.html", layout: {WebposWeb.LayoutView, "full_bg.html"})
  # end

  # def forget_password_email(conn, params) do
  #   user = Repo.get_by(User, email: params["email"])

  #   if user == nil do
  #     conn
  #     |> put_flash(:error, "User not found")
  #     |> redirect(to: user_path(conn, :forget_password, Settings.get_domain(conn)))
  #   else
  #     preset_password = "8888"
  #     crypted_password = Comeonin.Bcrypt.hashpwsalt(preset_password)
  #     p2 = String.replace(crypted_password, "$2b", "$2y")
  #     user_params = %{password: p2}

  #     changeset = Webpos.Settings.User.changeset(user, user_params)

  #     Webpos.Repo.update(changeset)
  #     password_not_set = true

  #     Webpos.Email.forget_password(
  #       user.email,
  #       preset_password,
  #       user.name,
  #       password_not_set
  #     )
  #     |> Webpos.Mailer.deliver_later()

  #     conn
  #     |> put_flash(:info, "Password has been sent to your email. Please check !")
  #     |> redirect(to: user_path(conn, :login))
  #   end
  # end

  def logout(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> delete_session(:organization_id)
    |> delete_session(:organization)
    |> put_flash(:info, "Logout successfully")
    |> redirect(to: user_path(conn, :login))
  end
end
