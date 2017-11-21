defmodule ChatWeb.ChatController do
  use ChatWeb, :controller

  def index(conn, _params) do
    render conn, "chat.html"
  end
end
