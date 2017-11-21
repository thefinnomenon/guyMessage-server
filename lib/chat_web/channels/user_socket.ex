defmodule ChatWeb.UserSocket do
  use Phoenix.Socket

  require Logger

  ## Channels
  channel "conversation:*", ChatWeb.ConversationChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    # Token %{id, username}
    case Phoenix.Token.verify(socket, "access", token, max_age: 86400) do
      {:ok, user} ->
        {:ok, assign(socket, :user, user)}
      {:error, _reason} ->
        :error
    end
  end

  def id(socket), do: "user_socket:#{socket.assigns.user.id}"
end
