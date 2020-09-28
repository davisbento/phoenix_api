# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phoenix_api,
  ecto_repos: [PhoenixApi.Repo]

# Configures the endpoint
config :phoenix_api, PhoenixApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hNuRBnaIS5cpPeK4z3GtZ80KktHXHJNKO1mfxiTe5GkA0Jdd7v4VHdoSlaShw2/f",
  render_errors: [view: PhoenixApiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PhoenixApi.PubSub,
  live_view: [signing_salt: "STpiFHwa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix_api, PhoenixApi.Guardian,
  issuer: "PhoenixApi",
  secret_key: "LiIvfw1n3+6pg4ROnvbcYMSYgEJiix4QpPjGJdFA0Tyb9HnH7FIv5cjq27iEmVkA"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
