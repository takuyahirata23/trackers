defmodule TrackersWeb.Router do
  use TrackersWeb, :router

  import TrackersWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TrackersWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TrackersWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrackersWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:trackers, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TrackersWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", TrackersWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{TrackersWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", TrackersWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{TrackersWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", TrackersWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{TrackersWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
      live "/users/dashboard", UserDashboardLive
      live "/users/motorcycles", UserMotorcyclesLive
      live "/users/motorcycles/:id", UserMotorcycleDetailLive
      live "/users/motorcycles/:id/maintenances/new", UserMotorcycleMaintenaceNewLive

      live "/users/motorcycles/:id/maintenances/:maintenance_id",
           UserMotorcycleMaintenanceDetailLive

      live "/users/trackdays", UserTrackdaysLive
      live "/users/trackdays/new", UserTrackdaysNewLive, :new
      live "/users/trackdays/:id", UserTrackdayDetailLive
      live "/tracks", TracksLive
      live "/tracks/:id", TrackDetailLive
      live "/tracks/:id/:layout_id", LayoutLive
    end
  end

  # Admin routes
  scope "/", TrackersWeb do
    pipe_through [:browser, :require_authenticated_user, :require_admin_user]

    live_session :admin,
      layout: {TrackersWeb.Layouts, :admin},
      on_mount: [
        {TrackersWeb.UserAuth, :ensure_authenticated},
        {TrackersWeb.UserAuth, :ensure_admin}
      ] do
      live "/admin/motorcycles", Admin.MotorcyclesLive
      live "/admin/tracks", Admin.TracksLive
    end
  end
end
