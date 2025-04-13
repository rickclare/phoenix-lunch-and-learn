defmodule LunchWeb.Router do
  use LunchWeb, :router

  import LunchWeb.UserAuth

  @default_on_mount [{LunchWeb.UserAuth, :mount_current_scope}]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LunchWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LunchWeb do
    pipe_through :browser

    get "/", PageController, :home

    live_session :demo, on_mount: @default_on_mount do
      live "/counter", CounterLive
      live "/image", ImageLive
      live "/drawing", DrawingBoardLive
    end

    live_session :ops, on_mount: @default_on_mount do
      live "/ops/users", UserLive.Index, :index
      live "/ops/users/new", UserLive.Form, :new
      live "/ops/users/:id", UserLive.Show, :show
      live "/ops/users/:id/edit", UserLive.Form, :edit
    end

    live_session :current_user, on_mount: @default_on_mount do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end

  ## Authentication routes

  scope "/", LunchWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{LunchWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  # Other scopes may use custom stacks.
  # scope "/api", LunchWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:lunch, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LunchWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
