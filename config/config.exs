# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :exercise2, Film.Repo,
  database: "exercise2_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :exercise2,
  ecto_repos: [Exercise2.Repo]

# Configures the endpoint
config :exercise2, Exercise2Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "I/pE5jhy4AB8ISM6vkDs7JWxUeuXHqQ1G//z0wp9VJfOAES+5tKKKph9YYQPwufz",
  render_errors: [view: Exercise2Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Exercise2.PubSub,
  live_view: [signing_salt: "p12nEnt7"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

# config :film, ecto_repos: [Film.Repo]

config :scrivener_html,
  routes_helper: Exercise2Web.Router.Helpers,
  # If you use a single view style everywhere, you can configure it here. See View Styles below for more info.
  view_style: :bootstrap

import_config "#{Mix.env()}.exs"
