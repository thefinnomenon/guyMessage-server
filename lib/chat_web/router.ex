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
  end

  scope "/chat", ChatWeb do
    pipe_through :browser
    pipe_through :secure_api

    get "/", ChatController, :index
  end
end
