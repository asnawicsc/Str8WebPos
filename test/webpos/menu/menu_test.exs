defmodule Webpos.MenuTest do
  use Webpos.DataCase

  alias Webpos.Menu

  describe "items" do
    alias Webpos.Menu.Item

    @valid_attrs %{code: "some code", customizations: "some customizations", desc: "some desc", img_url: "some img_url", name: "some name"}
    @update_attrs %{code: "some updated code", customizations: "some updated customizations", desc: "some updated desc", img_url: "some updated img_url", name: "some updated name"}
    @invalid_attrs %{code: nil, customizations: nil, desc: nil, img_url: nil, name: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Menu.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Menu.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Menu.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Menu.create_item(@valid_attrs)
      assert item.code == "some code"
      assert item.customizations == "some customizations"
      assert item.desc == "some desc"
      assert item.img_url == "some img_url"
      assert item.name == "some name"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Menu.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, item} = Menu.update_item(item, @update_attrs)
      assert %Item{} = item
      assert item.code == "some updated code"
      assert item.customizations == "some updated customizations"
      assert item.desc == "some updated desc"
      assert item.img_url == "some updated img_url"
      assert item.name == "some updated name"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Menu.update_item(item, @invalid_attrs)
      assert item == Menu.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Menu.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Menu.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Menu.change_item(item)
    end
  end

  describe "combos" do
    alias Webpos.Menu.Combo

    @valid_attrs %{category: "some category", category_limit: 42, combo_id: 42, item_id: 42}
    @update_attrs %{category: "some updated category", category_limit: 43, combo_id: 43, item_id: 43}
    @invalid_attrs %{category: nil, category_limit: nil, combo_id: nil, item_id: nil}

    def combo_fixture(attrs \\ %{}) do
      {:ok, combo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Menu.create_combo()

      combo
    end

    test "list_combos/0 returns all combos" do
      combo = combo_fixture()
      assert Menu.list_combos() == [combo]
    end

    test "get_combo!/1 returns the combo with given id" do
      combo = combo_fixture()
      assert Menu.get_combo!(combo.id) == combo
    end

    test "create_combo/1 with valid data creates a combo" do
      assert {:ok, %Combo{} = combo} = Menu.create_combo(@valid_attrs)
      assert combo.category == "some category"
      assert combo.category_limit == 42
      assert combo.combo_id == 42
      assert combo.item_id == 42
    end

    test "create_combo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Menu.create_combo(@invalid_attrs)
    end

    test "update_combo/2 with valid data updates the combo" do
      combo = combo_fixture()
      assert {:ok, combo} = Menu.update_combo(combo, @update_attrs)
      assert %Combo{} = combo
      assert combo.category == "some updated category"
      assert combo.category_limit == 43
      assert combo.combo_id == 43
      assert combo.item_id == 43
    end

    test "update_combo/2 with invalid data returns error changeset" do
      combo = combo_fixture()
      assert {:error, %Ecto.Changeset{}} = Menu.update_combo(combo, @invalid_attrs)
      assert combo == Menu.get_combo!(combo.id)
    end

    test "delete_combo/1 deletes the combo" do
      combo = combo_fixture()
      assert {:ok, %Combo{}} = Menu.delete_combo(combo)
      assert_raise Ecto.NoResultsError, fn -> Menu.get_combo!(combo.id) end
    end

    test "change_combo/1 returns a combo changeset" do
      combo = combo_fixture()
      assert %Ecto.Changeset{} = Menu.change_combo(combo)
    end
  end

  describe "organization_price" do
    alias Webpos.Menu.OrganizationPrice

    @valid_attrs %{name: "some name", organization_id: 42}
    @update_attrs %{name: "some updated name", organization_id: 43}
    @invalid_attrs %{name: nil, organization_id: nil}

    def organization_price_fixture(attrs \\ %{}) do
      {:ok, organization_price} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Menu.create_organization_price()

      organization_price
    end

    test "list_organization_price/0 returns all organization_price" do
      organization_price = organization_price_fixture()
      assert Menu.list_organization_price() == [organization_price]
    end

    test "get_organization_price!/1 returns the organization_price with given id" do
      organization_price = organization_price_fixture()
      assert Menu.get_organization_price!(organization_price.id) == organization_price
    end

    test "create_organization_price/1 with valid data creates a organization_price" do
      assert {:ok, %OrganizationPrice{} = organization_price} = Menu.create_organization_price(@valid_attrs)
      assert organization_price.name == "some name"
      assert organization_price.organization_id == 42
    end

    test "create_organization_price/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Menu.create_organization_price(@invalid_attrs)
    end

    test "update_organization_price/2 with valid data updates the organization_price" do
      organization_price = organization_price_fixture()
      assert {:ok, organization_price} = Menu.update_organization_price(organization_price, @update_attrs)
      assert %OrganizationPrice{} = organization_price
      assert organization_price.name == "some updated name"
      assert organization_price.organization_id == 43
    end

    test "update_organization_price/2 with invalid data returns error changeset" do
      organization_price = organization_price_fixture()
      assert {:error, %Ecto.Changeset{}} = Menu.update_organization_price(organization_price, @invalid_attrs)
      assert organization_price == Menu.get_organization_price!(organization_price.id)
    end

    test "delete_organization_price/1 deletes the organization_price" do
      organization_price = organization_price_fixture()
      assert {:ok, %OrganizationPrice{}} = Menu.delete_organization_price(organization_price)
      assert_raise Ecto.NoResultsError, fn -> Menu.get_organization_price!(organization_price.id) end
    end

    test "change_organization_price/1 returns a organization_price changeset" do
      organization_price = organization_price_fixture()
      assert %Ecto.Changeset{} = Menu.change_organization_price(organization_price)
    end
  end
end
