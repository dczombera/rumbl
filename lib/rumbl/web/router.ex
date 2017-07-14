defmodule Rumbl.Web.Router do
  use Rumbl.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Rumbl.Auth, context: Rumbl.ContentCreation
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Rumbl.Web do
    pipe_through :browser # Use the default browser stack

    resources "/users",    UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/",               PageController, :index
  end

  scope "/manage", Rumbl.Web do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Rumbl.Web do
  #   pipe_through :api
  # end
end
