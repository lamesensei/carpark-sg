use Mix.Config

database_url = System.get_env("TEST_DATABASE_URL")

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :carpark_sg, CarparkSg.Repo,
  url: database_url,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  adapter: Ecto.Adapters.Postgres,
  extensions: [{Geo.PostGIS.Extension, library: Geo}],
  types: CarparkSg.PostgresTypes,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :carpark_sg, CarparkSgWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
