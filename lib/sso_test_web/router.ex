defmodule SsoTestWeb.Router do
  use SsoTestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SsoTestWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SsoTestWeb do
    pipe_through :browser

    get "/", PageController, :home

    get "/page/sso", PageController, :sign_in
    get "/page/sso/refresh", PageController, :refresh_token
    get "/page/sso/end_session", PageController, :end_session
    get "/page/callback", PageController, :callback
    get "/signout", PageController, :signed_out
  end

  # Other scopes may use custom stacks.
  # scope "/api", SsoTestWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:sso_test, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SsoTestWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
