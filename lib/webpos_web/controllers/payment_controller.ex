defmodule WebposWeb.PaymentController do
  use WebposWeb, :controller

  alias Webpos.Settings
  alias Webpos.Settings.Payment

  def index(conn, _params) do
    payments = Settings.list_payments()
    render(conn, "index.html", payments: payments)
  end

  def new(conn, _params) do
    changeset = Settings.change_payment(%Payment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"payment" => payment_params}) do
    case Settings.create_payment(payment_params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment created successfully.")
        |> redirect(to: payment_path(conn, :show, payment))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    payment = Settings.get_payment!(id)
    render(conn, "show.html", payment: payment)
  end

  def edit(conn, %{"id" => id}) do
    payment = Settings.get_payment!(id)
    changeset = Settings.change_payment(payment)
    render(conn, "edit.html", payment: payment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Settings.get_payment!(id)

    case Settings.update_payment(payment, payment_params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment updated successfully.")
        |> redirect(to: payment_path(conn, :show, payment))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", payment: payment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment = Settings.get_payment!(id)
    {:ok, _payment} = Settings.delete_payment(payment)

    conn
    |> put_flash(:info, "Payment deleted successfully.")
    |> redirect(to: payment_path(conn, :index))
  end
end
