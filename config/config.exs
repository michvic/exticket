# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :exticket,
  ecto_repos: [Exticket.Repo]

# Configures the endpoint
config :exticket, ExticketWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/R1AbfcaDGaAVH9oWiHwXKZO3h4FCVgu8ECpa2l6yg8ufe7XO3l0xKP1DC7SO9+s",
  render_errors: [view: ExticketWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Exticket.PubSub,
  live_view: [signing_salt: "sy4QTn9I"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
