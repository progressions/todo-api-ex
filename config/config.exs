# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# General application configuration
config :todo, ecto_repos: [Todo.Repo]

# Configures the endpoint
config :todo, TodoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PNIM7I30u+mZ1IsPrw8wRnn0SQv3KUgkn+p0hXK5OY1eS1KVuzAja/tPegmBs8ev",
  render_errors: [view: TodoWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Todo.PubSub, adapter: Phoenix.PubSub.PG2]

config :todo, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: TodoWeb.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: TodoWeb.Endpoint
    ]
  }

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :plug_logger_json,
  filtered_keys: ["password", "authorization"],
  suppressed_keys: ["api_version", "log_type"]

config :logger,
  format: "$message\n",
  backends: [{LoggerFileBackend, :log_file}, :console]

config :logger, :log_file,
  format: "$message\n",
  level: :info,
  metadata: [:request_id],
  path: "log/#{Mix.env()}.log"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
