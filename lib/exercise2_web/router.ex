defmodule Exercise2Web.Router do
  use Exercise2Web, :router

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

  scope "/", Exercise2Web do
    pipe_through :browser

    get("/", PageController, :index)
    get("/save_file", PageController, :save_file)
    get("/fetch_number", PageController, :fetch_number)
    post("/import_file", PageController, :import_file)
    get("/save_database", PageController, :save_database)
    get("/exercise", ExerciseController, :index)
    get("/exercise2", Exercise2Controller, :index)


  end

  # Other scopes may use custom stacks.
  # scope "/api", Exercise2Web do
  #   pipe_through :api
  # end

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
      live_dashboard "/dashboard", metrics: Exercise2Web.Telemetry
    end
  end
end
