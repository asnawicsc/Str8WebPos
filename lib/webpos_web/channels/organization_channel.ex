defmodule WebposWeb.OrganizationChannel do
  use WebposWeb, :channel

  def join("organization:" <> code, payload, socket) do
    if authorized?(payload, code) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (organization:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(payload, code) do
    IO.inspect(payload)
    organization = Repo.get_by(Organization, name: code)

    password = Comeonin.Bcrypt.hashpwsalt(payload["license_key"])

    organization =
      if organization != nil do
        user =
          Repo.all(
            from(s in User,
              where: s.crypted_password == ^password
            )
          )
          |> hd

        %{password: user.crypted_password}
      else
        %{password: nil}
      end

    password == organization.password
  end
end
