defmodule PhoenixApiWeb.Router do
  use PhoenixApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :maybe_browser_auth do
  #   plug(Guardian.Plug.VerifySession)
  #   plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  #   plug(Guardian.Plug.LoadResource)
  # end

  # pipeline :auth do
  #   plug Guardian.Plug.Pipeline, module: PhoenixApi.GuardianSerializer,
  #                                error_handler: PhoenixApi.AuthErrorHandler

  #   plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  #   plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  #   plug Guardian.Plug.EnsureAuthenticated
  #   plug Guardian.Plug.LoadResource
  # end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixApiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/auth", PhoenixApiWeb do
    pipe_through :api

    post "/sign_in", AuthController, :sign_in
    post "/sign_up", AuthController, :sign_up
  end

  scope "/api/users", PhoenixApiWeb do
    pipe_through :api

    resources "/", UserController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PhoenixApiWeb.Telemetry
    end
  end
end
