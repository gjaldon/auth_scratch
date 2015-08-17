defmodule AuthScratch.Router do
  use AuthScratch.Web, :router

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

  scope "/", AuthScratch do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/register", RegistrationController, :index
    post "/register", RegistrationController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuthScratch do
  #   pipe_through :api
  # end
end
