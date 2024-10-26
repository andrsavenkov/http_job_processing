# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :http_job_processing,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :http_job_processing, HttpJobProcessingWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: HttpJobProcessingWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: HttpJobProcessing.PubSub,
  live_view: [signing_salt: "zyA4p1J4"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
