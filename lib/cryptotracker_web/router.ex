defmodule CryptotrackerWeb.Router do
  use CryptotrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :get_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  def get_current_user(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Cryptotracker.Users.get_user(user_id || -1)
    assign(conn, :current_user, user)
  end

  scope "/", CryptotrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/fetchAPI", PageController, :fetchAPI
    get "/home", PageController, :home
    resources "/users", UserController
    resources "/alerts", AlertController
    get "/alert", PageController, :alerts
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", CryptotrackerWeb do
  #   pipe_through :api
  # end
end
