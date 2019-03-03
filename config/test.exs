use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :todo, TodoWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :todo, Todo.Repo,
  username: System.get_env("PGUSER"),
  password: System.get_env("PGPASSWORD"),
  database: System.get_env("PGDATABASE"),
  hostname: System.get_env("PGHOST"),
  pool: Ecto.Adapters.SQL.Sandbox

config :todo, :dogstatsd, api: Todo.DogStatsd.Test
