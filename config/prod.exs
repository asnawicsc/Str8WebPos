use Mix.Config

config :webpos, WebposWeb.Endpoint,
  url: [host: "pos.str8.my", port: 443],
  http: [port: 8889],
  force_ssl: [hsts: true],
  https: [
    port: 443,
    otp_app: :webpos,
    keyfile: "/etc/letsencrypt/live/str8.my/privkey.pem",
    cacertfile: "/etc/letsencrypt/live/str8.my/fullchain.pem",
    certfile: "/etc/letsencrypt/live/str8.my/cert.pem"
  ],
  check_origin: ["https://pos.str8.my"]

config :logger, level: :info

config :webpos, WebposWeb.Endpoint, server: true

# config :webpos, Webpos.Repo,
#   adapter: Ecto.Adapters.MySQL,
#   hostname: "110.4.42.47",
#   port: "15100",
#   username: "phoenix_bn",
#   password: "123123",
#   database: "posgb_Webpos",
#   pool_size: 10,
#   timeout: 90000

config :webpos, Webpos.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "webpos_prod",
  hostname: "localhost",
  pool_size: 10
