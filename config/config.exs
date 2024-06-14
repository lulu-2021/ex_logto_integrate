# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :sso_test,
  ecto_repos: [SsoTest.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :sso_test, SsoTestWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SsoTestWeb.ErrorHTML, json: SsoTestWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SsoTest.PubSub,
  live_view: [signing_salt: "gPOuQRyB"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :sso_test, SsoTest.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  sso_test: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  sso_test: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_logto, :callback_url, "http://lvh.me:4000/page/callback"
config :ex_logto, :client_id, "2a2yi37r08mv2ujr0dhf8"
config :ex_logto, :client_secret, "qPl7Oc8Dxi1VGDDJwYpKjlL7WX99Xemj"
config :ex_logto, :authorization_endpoint, "http://localhost:3001/oidc/auth/"
config :ex_logto, :token_endpoint, "http://localhost:3001/oidc/token/"
config :ex_logto, :end_session_endpoint, "http://localhost:3001/oidc/session/end"
config :ex_logto, :user_info_endpoint, "http://localhost:3001/oidc/me/"
config :ex_logto, :post_logout_redirect_url, "http://lvh.me:4000/"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
