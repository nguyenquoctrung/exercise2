defmodule Exercise2.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Exercise2.Repo,
      # Start the Telemetry supervisor
      Exercise2Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Exercise2.PubSub},
      # Start the Endpoint (http/https)
      Exercise2Web.Endpoint
      # Start a worker by calling: Exercise2.Worker.start_link(arg)
      # {Exercise2.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exercise2.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Exercise2Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
