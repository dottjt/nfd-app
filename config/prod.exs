use Mix.Config

# config :stripity_stripe, 
#   api_key: System.get_env("STRIPE_SECRET_KEY"),
#   json_library: Jason

# Mailer setup
config :nfd, Nfd.SwooshMailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: "us-east-1",
  access_key: System.get_env("AWS_ACCESS_KEY"),
  secret: System.get_env("AWS_SECRET_KEY") 

config :nfd, :pow_assent,
  providers:
       [
        # facebook: [
        #   client_id: "REPLACE_WITH_CLIENT_ID",
        #   client_secret: "REPLACE_WITH_CLIENT_SECRET",
        #   strategy: PowAssent.Strategy.Facebook
        # ],
        google: [
          client_id: System.get_env("GOOGLE_CLIENT_ID"),
          client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
          strategy: PowAssent.Strategy.Google
        ],
        # vk: [
        #   consumer_key: "REPLACE_WITH_CONSUMER_KEY",
        #   consumer_secret: "REPLACE_WITH_CONSUMER_SECRET",
        #   strategy: PowAssent.Strategy.Twitter
        # ]
      ]

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :nfd, NfdWeb.Endpoint,
  http: [port: 4000],
  url: [host: System.get_env("HOST"), port: 80],
  # https: [
  #   port: 443,
  #   otp_app: :nfd,
  #   keyfile: "/fullchain.pem",
  #   certfile: "/privkey.pem",
  # ],
  # force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: "."
  # https: [
  #   port: 443,
  #   otp_app: :nfd,
  #   keyfile: System.get_env("SSL_KEY_FILE"),
  #   certfile: System.get_env("SSL_CERT_FILE"),
  # ]



# Configure your database
config :nfd, Nfd.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: System.get_env("POSTGRES_DB"),
  hostname: System.get_env("POSTGRES_HOST"),
  pool_size: 15


# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :nfd, NfdWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         :inet6,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :nfd, NfdWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases (distillery)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :nfd, NfdWeb.Endpoint, server: true
#
# Note you can't rely on `System.get_env/1` when using releases.
# See the releases documentation accordingly.

# Finally import the config/prod.secret.exs which should be versioned
# separately.

# import_config "prod.secret.exs"
