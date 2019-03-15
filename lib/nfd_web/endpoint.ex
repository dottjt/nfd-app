defmodule NfdWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :nfd

  socket "/socket", NfdWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :nfd,
    gzip: false,
    only: ~w(css fonts images sitemaps js favicon.ico robots.txt podcast.xml)

  # plug Plug.Static,
  #   at: "/torch",
  #   from: {:torch, "priv/static"},
  #   gzip: true,
  #   cache_control_for_etags: "public, max-age=86400"

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason # Phoenix.json_library()


  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_nfd_key",
    signing_salt: "vsK5HnrP" # "secret"

  plug Pow.Plug.Session, otp_app: :nfd

  # Web Plugs
  plug NfdWeb.Router

  # This is what the instruction says when generating POW Assent templates, but it doesn't seem to be working?

  # Please set `web_module: NfdWeb` in your configuration.
  # defmodule NfdWeb.Endpoint do

end
