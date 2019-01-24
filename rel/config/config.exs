# It's for runtime configuration, compare to PROJ_ROOT/config/*.exs are for compile time configuration
use Mix.Config

config :phx_template, PhxTemplate.Repo,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  pool_size: 15

port = String.to_integer(System.get_env("PORT") || "8080")

config :phx_template, PhxTemplateWeb.Endpoint,
  http: [:inet6, port: port],
  url: [host: System.get_env("HOSTNAME"), port: port],
  secret_key_base: System.get_env("SECRET_KEY_BASE")
