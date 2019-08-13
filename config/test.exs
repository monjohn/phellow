use Mix.Config

# Configure your database
config :phellow, Phellow.Repo,
  username: "postgres",
  password: "postgres",
  database: "phellow_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phellow, PhellowWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
