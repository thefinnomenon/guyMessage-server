defmodule ChatWeb.ConversationChannel do
  use Phoenix.Channel
  alias ChatWeb.Presence
  
  require Logger

  def join("conversation:1", _payload, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:seconds))
      })
    {:noreply, socket}
  end

  def handle_in("message:new", payload, socket) do
    broadcast! socket, "message:new", %{user: "some-guy", message: payload["message"]}
    {:noreply, socket}
  end
end