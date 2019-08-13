# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phellow,
  ecto_repos: [Phellow.Repo]

# Configures the endpoint
config :phellow, PhellowWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4qBqV8Gg9B3l6kC9FOYXrQLAU0lcTq7xT8qHWRw+mimehLhkylzY1nF0tli2MdF/",
  render_errors: [view: PhellowWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phellow.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
