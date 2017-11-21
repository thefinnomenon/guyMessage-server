defmodule Chat.VerifySession do

import Plug.Conn

import Phoenix.Controller

require Logger

@doc """
  Plug
    Used in a router pipeline to verify token and extract user_id
  """
  def init(opts), do: opts

  def call(conn, repo) do 
    case get_session(conn) do
      {nil, _} -> conn |> put_flash(:error, "Please login") |> redirect(to: "/") |> halt
      {user_id, username} -> assign(conn, :user, %{:id => user_id, :username => username})
    end
  end

  defp get_session(conn) do 
  	user_id = get_session(conn, :user_id)
  	username = get_session(conn, :username)

  	{user_id, username}
  end
end