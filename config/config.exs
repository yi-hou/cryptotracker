# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cryptotracker,
  ecto_repos: [Cryptotracker.Repo]

# Configures the endpoint
config :cryptotracker, CryptotrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OGhaezZMQk77IKAAr7FNEiUxV3UluAvOZwyML4saptRDHGxlZmEjd3VF/6oNOgfB",
  render_errors: [view: CryptotrackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cryptotracker.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Attribution: BAmboo_SMTP Setup
# Link: https://github.com/fewlinesco/bamboo_smtp
config :cryptotracker, Cryptotracker.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  hostname: "auroboro.com",
  port: 587,
  username: "henryzhou95@gmail.com", # or {:system, "SMTP_USERNAME"}
  password: "4te6nda4", # or {:system, "SMTP_PASSWORD"}
  tls: :if_available, # can be `:always` or `:never`
  allowed_tls_versions: [:"tlsv1", :"tlsv1.1", :"tlsv1.2"], # or {":system", ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
  ssl: false, # can be `true`
  retries: 1,
  no_mx_lookups: false # can be `true`

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
