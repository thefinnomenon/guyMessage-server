defmodule ChatWeb.ChatView do
  use ChatWeb, :view

  def cookies(conn, cookie_name) do
  	conn.cookies[cookie_name]
  end
end
