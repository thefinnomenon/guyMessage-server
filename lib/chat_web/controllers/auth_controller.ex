defmodule ChatWeb.AuthController do
  use ChatWeb, :controller

  import Ecto.Query, only: [from: 2]

  alias Chat.Repo
  alias Chat.Accounts
  alias Chat.Accounts.User

  alias Phoenix.Token

  require Logger
  
  def index(conn, _params) do
    render conn, "index.html"
  end

  @doc """
  Retrieves a list of users
  """
  def get_user_list() do
    Repo.all(User)
    |> Enum.map(fn(user) -> %{:id => user.id, :username => user.username} end)
  end

  @doc """
   Retrieve the user_id associated with the username (create a user entry if necessary). 
   Return a Phoenix token for the user
  """
  def login(conn, _params) do
  	%{:body_params => %{"username" => username}} = conn

    query = from u in "users", where: u.username == ^username, select: u.id

    case Repo.one(query) do
      nil -> 
        case Accounts.create_user(%{username: username}) do
          {:ok, resp}       -> 
            resp.id |> send_access_token(username, conn)
          {:error, reason}  -> conn |> put_flash(:error, "Please try again") |> render("index.html")
        end
      user_id -> user_id |> UUID.binary_to_string! |> send_access_token(username, conn)
    end
  end

  @doc """
   Logs user out by deleting the session cookie & redirecting
   to the login page
  """
  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  defp send_access_token(user_id, username, conn) do
    token = Phoenix.Token.sign(ChatWeb.Endpoint, "access", %{id: user_id, username: username})
    conn 
    |> put_session(:user_id, user_id)
    |> put_session(:username, username)
    |> put_resp_cookie("user_token", token, max_age: 24*60*60)
    |> put_resp_cookie("username", username, max_age: 24*60*60)
    |> send_resp(200, "") #redirect(to: "/chat")
  end
end
