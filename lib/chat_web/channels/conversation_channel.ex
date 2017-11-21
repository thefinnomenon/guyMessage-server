defmodule ChatWeb.ConversationChannel do
  use Phoenix.Channel
  alias ChatWeb.Presence
  alias Chat.Chats.Chat
  
  require Logger

  def join("conversation:lobby", _payload, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("conversation:" <> game_id, _payload, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast! socket, "message:new", %{user: "system", message: "#{socket.assigns.user.username} joined the room"}
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.user.id, %{})
    {:noreply, socket}
  end

  def handle_in("message:new", payload, socket) do
    broadcast! socket, "message:new", %{user: socket.assigns.user.username, message: payload["message"]}
    {:noreply, socket}
  end

  def handle_in("get_conversations", payload, socket) do
    conversations = Chat.get_conversation_list(socket.assigns.user.id)
    {:reply, {:ok, %{:conversations => conversations}}, socket}
  end
end