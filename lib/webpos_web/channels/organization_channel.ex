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
    IO.inspect(payload["license_key"])
    password = Comeonin.Bcrypt.hashpwsalt(payload["license_key"])
    IO.inspect(organization)

    organization =
      if organization != nil do
        user =
          Repo.all(
            from(s in User,
              where: s.organization == ^organization.id
            )
          )

        check =
          for item <- user do
            pass =
              if Comeonin.Bcrypt.hashpwsalt(payload["license_key"], item.crypted_password) == true do
                %{password: payload["license_key"]}
              else
                %{password: nil}
              end

            pass
          end
          |> Enum.filter(fn x -> x.password != nil end)

        IO.inspect(check)

        user =
          if check != [] do
            check |> hd

            %{password: check.password}
          else
            %{password: nil}
          end

        user
      else
        %{password: nil}
      end

    IO.inspect(password)
    IO.inspect(organization.password)
    a = payload["license_key"] == organization.password
    IO.inspect(a)

    a
  end
end
