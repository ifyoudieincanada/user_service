# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :user_service,
  ecto_repos: [UserService.Repo]

# Configures the endpoint
config :user_service, UserService.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7tnn5CnJ2WGDNLOWfSYlyyuUbZ6WvpGfHIP9OyVCYfwo4iH2MOciFrxDNzhT9xv3",
  render_errors: [view: UserService.ErrorView, accepts: ~w(json)],
  pubsub: [name: UserService.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
