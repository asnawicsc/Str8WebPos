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

  describe "printers" do
    alias Webpos.Menu.Printer

    @valid_attrs %{ip_address: "some ip_address", name: "some name", organization_id: 42, port_no: "some port_no"}
    @update_attrs %{ip_address: "some updated ip_address", name: "some updated name", organization_id: 43, port_no: "some updated port_no"}
    @invalid_attrs %{ip_address: nil, name: nil, organization_id: nil, port_no: nil}

    def printer_fixture(attrs \\ %{}) do
      {:ok, printer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Menu.create_printer()

      printer
    end

    test "list_printers/0 returns all printers" do
      printer = printer_fixture()
      assert Menu.list_printers() == [printer]
    end

    test "get_printer!/1 returns the printer with given id" do
      printer = printer_fixture()
      assert Menu.get_printer!(printer.id) == printer
    end

    test "create_printer/1 with valid data creates a printer" do
      assert {:ok, %Printer{} = printer} = Menu.create_printer(@valid_attrs)
      assert printer.ip_address == "some ip_address"
      assert printer.name == "some name"
      assert printer.organization_id == 42
      assert printer.port_no == "some port_no"
    end

    test "create_printer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Menu.create_printer(@invalid_attrs)
    end

    test "update_printer/2 with valid data updates the printer" do
      printer = printer_fixture()
      assert {:ok, printer} = Menu.update_printer(printer, @update_attrs)
      assert %Printer{} = printer
      assert printer.ip_address == "some updated ip_address"
      assert printer.name == "some updated name"
      assert printer.organization_id == 43
      assert printer.port_no == "some updated port_no"
    end

    test "update_printer/2 with invalid data returns error changeset" do
      printer = printer_fixture()
      assert {:error, %Ecto.Changeset{}} = Menu.update_printer(printer, @invalid_attrs)
      assert printer == Menu.get_printer!(printer.id)
    end

    test "delete_printer/1 deletes the printer" do
      printer = printer_fixture()
      assert {:ok, %Printer{}} = Menu.delete_printer(printer)
      assert_raise Ecto.NoResultsError, fn -> Menu.get_printer!(printer.id) end
    end

    test "change_printer/1 returns a printer changeset" do
      printer = printer_fixture()
      assert %Ecto.Changeset{} = Menu.change_printer(printer)
    end
  end

  describe "discounts" do
    alias Webpos.Menu.Discount

    @valid_attrs %{amount: 120.5, category: "some category", description: "some description", disc_type: "some disc_type", name: "some name", requirements: "some requirements", targets: "some targets"}
    @update_attrs %{amount: 456.7, category: "some updated category", description: "some updated description", disc_type: "some updated disc_type", name: "some updated name", requirements: "some updated requirements", targets: "some updated targets"}
    @invalid_attrs %{amount: nil, category: nil, description: nil, disc_type: nil, name: nil, requirements: nil, targets: nil}

    def discount_fixture(attrs \\ %{}) do
      {:ok, discount} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Menu.create_discount()

      discount
    end

    test "list_discounts/0 returns all discounts" do
      discount = discount_fixture()
      assert Menu.list_discounts() == [discount]
    end

    test "get_discount!/1 returns the discount with given id" do
      discount = discount_fixture()
      assert Menu.get_discount!(discount.id) == discount
    end

    test "create_discount/1 with valid data creates a discount" do
      assert {:ok, %Discount{} = discount} = Menu.create_discount(@valid_attrs)
      assert discount.amount == 120.5
      assert discount.category == "some category"
      assert discount.description == "some description"
      assert discount.disc_type == "some disc_type"
      assert discount.name == "some name"
      assert discount.requirements == "some requirements"
      assert discount.targets == "some targets"
    end

    test "create_discount/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Menu.create_discount(@invalid_attrs)
    end

    test "update_discount/2 with valid data updates the discount" do
      discount = discount_fixture()
      assert {:ok, discount} = Menu.update_discount(discount, @update_attrs)
      assert %Discount{} = discount
      assert discount.amount == 456.7
      assert discount.category == "some updated category"
      assert discount.description == "some updated description"
      assert discount.disc_type == "some updated disc_type"
      assert discount.name == "some updated name"
      assert discount.requirements == "some updated requirements"
      assert discount.targets == "some updated targets"
    end

    test "update_discount/2 with invalid data returns error changeset" do
      discount = discount_fixture()
      assert {:error, %Ecto.Changeset{}} = Menu.update_discount(discount, @invalid_attrs)
      assert discount == Menu.get_discount!(discount.id)
    end

    test "delete_discount/1 deletes the discount" do
      discount = discount_fixture()
      assert {:ok, %Discount{}} = Menu.delete_discount(discount)
      assert_raise Ecto.NoResultsError, fn -> Menu.get_discount!(discount.id) end
    end

    test "change_discount/1 returns a discount changeset" do
      discount = discount_fixture()
      assert %Ecto.Changeset{} = Menu.change_discount(discount)
    end
  end
end
