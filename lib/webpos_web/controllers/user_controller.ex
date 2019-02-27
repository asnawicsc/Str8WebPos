defmodule WebposWeb.UserController do
  use WebposWeb, :controller

  alias Webpos.Settings
  alias Webpos.Settings.User
  require IEx

  def index(conn, params) do
    user = Settings.current_user(conn)

    users =
      if params["q"] != nil do
        Repo.all(
          from(
            u in User,
            where: u.user_type == "Staff" and u.organization_id == ^user.organization_id
          )
        )
      else
        Settings.list_users(user.organization_id)
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

    if user.user_type == "Admin" do
    else
      user_params = Map.put(user_params, "organization_id", Settings.get_org_id(conn))
    end

    user_params =
      if user_params["password"] != "" do
        Map.put(
          user_params,
          "crypted_password",
          Comeonin.Bcrypt.hashpwsalt(user_params["password"])
        )
        |> Map.put("password", nil)
      else
        Map.delete(user_params, "password")
      end

    user_name = conn.private.plug_session["user_name"]
    user_type = conn.private.plug_session["user_type"]
    org_id = conn.private.plug_session["org_id"]

    log_before =
      user |> Map.from_struct() |> Map.drop([:__meta__, :__struct__]) |> Poison.encode!()

    case Settings.update_user(user, user_params) do
      {:ok, user} ->
        log_after =
          user
          |> Map.from_struct()
          |> Map.drop([:__meta__, :__struct__])
          |> Poison.encode!()

        a = log_before |> Poison.decode!() |> Enum.map(fn x -> x end)
        b = log_after |> Poison.decode!() |> Enum.map(fn x -> x end)
        bef = a -- b
        aft = b -- a

        fullsec =
          for item <- aft |> Enum.filter(fn x -> x |> elem(0) != "updated_at" end) do
            data = item |> elem(0)
            data2 = item |> elem(1)

            bef = bef |> Enum.filter(fn x -> x |> elem(0) == data end) |> hd

            full_bef = bef |> elem(1)

            fullsec = data <> ": change " <> full_bef <> " to " <> data2
            fullsec
          end
          |> Poison.encode!()

        datetime = Timex.now() |> DateTime.to_naive()

        modal_log_params = %{
          user_name: user_name,
          user_type: user_type,
          before_change: log_before,
          after_change: log_after,
          datetime: datetime,
          category: conn.path_info |> hd,
          primary_id: user.id,
          changes: fullsec,
          organization_id: org_id
        }

        Reports.create_modal_lllog(modal_log_params)

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

    if user != nil do
      org = Repo.get(Organization, user.organization_id)
      org_name = Base.url_encode64(org.name)

      if Comeonin.Bcrypt.checkpw(password, user.crypted_password) do
        conn
        |> put_flash(:info, "Welcome!")
        |> put_session(:user_id, user.id)
        |> put_session(:org_id, user.organization_id)
        |> put_session(:org_name, org_name)
        |> put_session(:user_name, user.username)
        |> put_session(:user_type, user.user_type)
        |> put_session(:super_admin, check_super(user.id))
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

  def check_super(id) do
    user = Repo.get(User, id)
    user.organization_id == 1
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
