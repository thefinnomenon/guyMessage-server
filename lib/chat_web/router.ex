defmodule ChatWeb.Router do
  use ChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :secure_api do
    plug Chat.VerifySession
  end

  scope "/", ChatWeb do
    pipe_through :browser

    get "/", AuthController, :index
    post "/auth", AuthController, :login
    get "/auth/logout", AuthController, :logout
    get "/users", AuthController, :get_user_list
  end

  scope "/api/auth", ChatWeb do
    pipe_through :api

    post "/", AuthController, :login
  end

  scope "/api/", ChatWeb do
    pipe_through :secure_api

    get "/chat", ChatController, :index
    get "/users", AuthController, :get_user_list
    get "/auth/logout", AuthController, :logout
  end
end
