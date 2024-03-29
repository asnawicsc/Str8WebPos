defmodule Webpos.SettingsTest do
  use Webpos.DataCase

  alias Webpos.Settings

  describe "users" do
    alias Webpos.Settings.User

    @valid_attrs %{crypted_password: "some crypted_password", email: "some email", password: "some password", username: "some username"}
    @update_attrs %{crypted_password: "some updated crypted_password", email: "some updated email", password: "some updated password", username: "some updated username"}
    @invalid_attrs %{crypted_password: nil, email: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Settings.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Settings.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Settings.create_user(@valid_attrs)
      assert user.crypted_password == "some crypted_password"
      assert user.email == "some email"
      assert user.password == "some password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Settings.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.crypted_password == "some updated crypted_password"
      assert user.email == "some updated email"
      assert user.password == "some updated password"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_user(user, @invalid_attrs)
      assert user == Settings.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Settings.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Settings.change_user(user)
    end
  end

  describe "organizations" do
    alias Webpos.Settings.Organization

    @valid_attrs %{address: "some address", name: "some name"}
    @update_attrs %{address: "some updated address", name: "some updated name"}
    @invalid_attrs %{address: nil, name: nil}

    def organization_fixture(attrs \\ %{}) do
      {:ok, organization} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_organization()

      organization
    end

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Settings.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Settings.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      assert {:ok, %Organization{} = organization} = Settings.create_organization(@valid_attrs)
      assert organization.address == "some address"
      assert organization.name == "some name"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      assert {:ok, organization} = Settings.update_organization(organization, @update_attrs)
      assert %Organization{} = organization
      assert organization.address == "some updated address"
      assert organization.name == "some updated name"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_organization(organization, @invalid_attrs)
      assert organization == Settings.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Settings.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Settings.change_organization(organization)
    end
  end

  describe "restaurants" do
    alias Webpos.Settings.Restaurant

    @valid_attrs %{address: "some address", code: "some code", key: "some key", name: "some name", reg_id: "some reg_id", tax_code: "some tax_code", tax_id: "some tax_id"}
    @update_attrs %{address: "some updated address", code: "some updated code", key: "some updated key", name: "some updated name", reg_id: "some updated reg_id", tax_code: "some updated tax_code", tax_id: "some updated tax_id"}
    @invalid_attrs %{address: nil, code: nil, key: nil, name: nil, reg_id: nil, tax_code: nil, tax_id: nil}

    def restaurant_fixture(attrs \\ %{}) do
      {:ok, restaurant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_restaurant()

      restaurant
    end

    test "list_restaurants/0 returns all restaurants" do
      restaurant = restaurant_fixture()
      assert Settings.list_restaurants() == [restaurant]
    end

    test "get_restaurant!/1 returns the restaurant with given id" do
      restaurant = restaurant_fixture()
      assert Settings.get_restaurant!(restaurant.id) == restaurant
    end

    test "create_restaurant/1 with valid data creates a restaurant" do
      assert {:ok, %Restaurant{} = restaurant} = Settings.create_restaurant(@valid_attrs)
      assert restaurant.address == "some address"
      assert restaurant.code == "some code"
      assert restaurant.key == "some key"
      assert restaurant.name == "some name"
      assert restaurant.reg_id == "some reg_id"
      assert restaurant.tax_code == "some tax_code"
      assert restaurant.tax_id == "some tax_id"
    end

    test "create_restaurant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_restaurant(@invalid_attrs)
    end

    test "update_restaurant/2 with valid data updates the restaurant" do
      restaurant = restaurant_fixture()
      assert {:ok, restaurant} = Settings.update_restaurant(restaurant, @update_attrs)
      assert %Restaurant{} = restaurant
      assert restaurant.address == "some updated address"
      assert restaurant.code == "some updated code"
      assert restaurant.key == "some updated key"
      assert restaurant.name == "some updated name"
      assert restaurant.reg_id == "some updated reg_id"
      assert restaurant.tax_code == "some updated tax_code"
      assert restaurant.tax_id == "some updated tax_id"
    end

    test "update_restaurant/2 with invalid data returns error changeset" do
      restaurant = restaurant_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_restaurant(restaurant, @invalid_attrs)
      assert restaurant == Settings.get_restaurant!(restaurant.id)
    end

    test "delete_restaurant/1 deletes the restaurant" do
      restaurant = restaurant_fixture()
      assert {:ok, %Restaurant{}} = Settings.delete_restaurant(restaurant)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_restaurant!(restaurant.id) end
    end

    test "change_restaurant/1 returns a restaurant changeset" do
      restaurant = restaurant_fixture()
      assert %Ecto.Changeset{} = Settings.change_restaurant(restaurant)
    end
  end

  describe "payments" do
    alias Webpos.Settings.Payment

    @valid_attrs %{description: "some description", name: "some name", regex: "some regex"}
    @update_attrs %{description: "some updated description", name: "some updated name", regex: "some updated regex"}
    @invalid_attrs %{description: nil, name: nil, regex: nil}

    def payment_fixture(attrs \\ %{}) do
      {:ok, payment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_payment()

      payment
    end

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Settings.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Settings.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      assert {:ok, %Payment{} = payment} = Settings.create_payment(@valid_attrs)
      assert payment.description == "some description"
      assert payment.name == "some name"
      assert payment.regex == "some regex"
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()
      assert {:ok, payment} = Settings.update_payment(payment, @update_attrs)
      assert %Payment{} = payment
      assert payment.description == "some updated description"
      assert payment.name == "some updated name"
      assert payment.regex == "some updated regex"
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_payment(payment, @invalid_attrs)
      assert payment == Settings.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Settings.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Settings.change_payment(payment)
    end
  end

  describe "tables" do
    alias Webpos.Settings.Table

    @valid_attrs %{name: "some name", pos_x: 120.5, pos_y: 120.5, rest_id: 42, rest_table_id: 42}
    @update_attrs %{name: "some updated name", pos_x: 456.7, pos_y: 456.7, rest_id: 43, rest_table_id: 43}
    @invalid_attrs %{name: nil, pos_x: nil, pos_y: nil, rest_id: nil, rest_table_id: nil}

    def table_fixture(attrs \\ %{}) do
      {:ok, table} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_table()

      table
    end

    test "list_tables/0 returns all tables" do
      table = table_fixture()
      assert Settings.list_tables() == [table]
    end

    test "get_table!/1 returns the table with given id" do
      table = table_fixture()
      assert Settings.get_table!(table.id) == table
    end

    test "create_table/1 with valid data creates a table" do
      assert {:ok, %Table{} = table} = Settings.create_table(@valid_attrs)
      assert table.name == "some name"
      assert table.pos_x == 120.5
      assert table.pos_y == 120.5
      assert table.rest_id == 42
      assert table.rest_table_id == 42
    end

    test "create_table/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_table(@invalid_attrs)
    end

    test "update_table/2 with valid data updates the table" do
      table = table_fixture()
      assert {:ok, table} = Settings.update_table(table, @update_attrs)
      assert %Table{} = table
      assert table.name == "some updated name"
      assert table.pos_x == 456.7
      assert table.pos_y == 456.7
      assert table.rest_id == 43
      assert table.rest_table_id == 43
    end

    test "update_table/2 with invalid data returns error changeset" do
      table = table_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_table(table, @invalid_attrs)
      assert table == Settings.get_table!(table.id)
    end

    test "delete_table/1 deletes the table" do
      table = table_fixture()
      assert {:ok, %Table{}} = Settings.delete_table(table)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_table!(table.id) end
    end

    test "change_table/1 returns a table changeset" do
      table = table_fixture()
      assert %Ecto.Changeset{} = Settings.change_table(table)
    end
  end

  describe "patrons" do
    alias Webpos.Settings.Patron

    @valid_attrs %{birthday: "some birthday", name: "some name", phone: "some phone", points: 42, remarks: "some remarks", rest_id: 42}
    @update_attrs %{birthday: "some updated birthday", name: "some updated name", phone: "some updated phone", points: 43, remarks: "some updated remarks", rest_id: 43}
    @invalid_attrs %{birthday: nil, name: nil, phone: nil, points: nil, remarks: nil, rest_id: nil}

    def patron_fixture(attrs \\ %{}) do
      {:ok, patron} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_patron()

      patron
    end

    test "list_patrons/0 returns all patrons" do
      patron = patron_fixture()
      assert Settings.list_patrons() == [patron]
    end

    test "get_patron!/1 returns the patron with given id" do
      patron = patron_fixture()
      assert Settings.get_patron!(patron.id) == patron
    end

    test "create_patron/1 with valid data creates a patron" do
      assert {:ok, %Patron{} = patron} = Settings.create_patron(@valid_attrs)
      assert patron.birthday == "some birthday"
      assert patron.name == "some name"
      assert patron.phone == "some phone"
      assert patron.points == 42
      assert patron.remarks == "some remarks"
      assert patron.rest_id == 42
    end

    test "create_patron/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_patron(@invalid_attrs)
    end

    test "update_patron/2 with valid data updates the patron" do
      patron = patron_fixture()
      assert {:ok, patron} = Settings.update_patron(patron, @update_attrs)
      assert %Patron{} = patron
      assert patron.birthday == "some updated birthday"
      assert patron.name == "some updated name"
      assert patron.phone == "some updated phone"
      assert patron.points == 43
      assert patron.remarks == "some updated remarks"
      assert patron.rest_id == 43
    end

    test "update_patron/2 with invalid data returns error changeset" do
      patron = patron_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_patron(patron, @invalid_attrs)
      assert patron == Settings.get_patron!(patron.id)
    end

    test "delete_patron/1 deletes the patron" do
      patron = patron_fixture()
      assert {:ok, %Patron{}} = Settings.delete_patron(patron)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_patron!(patron.id) end
    end

    test "change_patron/1 returns a patron changeset" do
      patron = patron_fixture()
      assert %Ecto.Changeset{} = Settings.change_patron(patron)
    end
  end

  describe "patron_points" do
    alias Webpos.Settings.PatronPoint

    @valid_attrs %{accumulated: 42, in: 42, out: 42, patron_id: 42, remarks: "some remarks", salesdate: ~D[2010-04-17], salesid: "some salesid"}
    @update_attrs %{accumulated: 43, in: 43, out: 43, patron_id: 43, remarks: "some updated remarks", salesdate: ~D[2011-05-18], salesid: "some updated salesid"}
    @invalid_attrs %{accumulated: nil, in: nil, out: nil, patron_id: nil, remarks: nil, salesdate: nil, salesid: nil}

    def patron_point_fixture(attrs \\ %{}) do
      {:ok, patron_point} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_patron_point()

      patron_point
    end

    test "list_patron_points/0 returns all patron_points" do
      patron_point = patron_point_fixture()
      assert Settings.list_patron_points() == [patron_point]
    end

    test "get_patron_point!/1 returns the patron_point with given id" do
      patron_point = patron_point_fixture()
      assert Settings.get_patron_point!(patron_point.id) == patron_point
    end

    test "create_patron_point/1 with valid data creates a patron_point" do
      assert {:ok, %PatronPoint{} = patron_point} = Settings.create_patron_point(@valid_attrs)
      assert patron_point.accumulated == 42
      assert patron_point.in == 42
      assert patron_point.out == 42
      assert patron_point.patron_id == 42
      assert patron_point.remarks == "some remarks"
      assert patron_point.salesdate == ~D[2010-04-17]
      assert patron_point.salesid == "some salesid"
    end

    test "create_patron_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_patron_point(@invalid_attrs)
    end

    test "update_patron_point/2 with valid data updates the patron_point" do
      patron_point = patron_point_fixture()
      assert {:ok, patron_point} = Settings.update_patron_point(patron_point, @update_attrs)
      assert %PatronPoint{} = patron_point
      assert patron_point.accumulated == 43
      assert patron_point.in == 43
      assert patron_point.out == 43
      assert patron_point.patron_id == 43
      assert patron_point.remarks == "some updated remarks"
      assert patron_point.salesdate == ~D[2011-05-18]
      assert patron_point.salesid == "some updated salesid"
    end

    test "update_patron_point/2 with invalid data returns error changeset" do
      patron_point = patron_point_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_patron_point(patron_point, @invalid_attrs)
      assert patron_point == Settings.get_patron_point!(patron_point.id)
    end

    test "delete_patron_point/1 deletes the patron_point" do
      patron_point = patron_point_fixture()
      assert {:ok, %PatronPoint{}} = Settings.delete_patron_point(patron_point)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_patron_point!(patron_point.id) end
    end

    test "change_patron_point/1 returns a patron_point changeset" do
      patron_point = patron_point_fixture()
      assert %Ecto.Changeset{} = Settings.change_patron_point(patron_point)
    end
  end
end
