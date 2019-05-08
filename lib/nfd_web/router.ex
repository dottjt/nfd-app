defmodule NfdWeb.Router do
  use NfdWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, otp_app: :nfd
  use PowAssent.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NavigationHistory.Tracker
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()
    pow_assent_routes()
  end

  scope "/", NfdWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/guide", PageController, :guide
    get "/community", PageController, :community
    get "/about", PageController, :about
    get "/contact", PageController, :contact
    get "/disclaimer", PageController, :disclaimer
    get "/privacy", PageController, :privacy
    get "/terms-and-conditions", PageController, :terms_and_conditions
    get "/accountability-program", PageController, :accountability
    get "/new-fap-deluxe-reddit-guidelines", PageController, :reddit_guidelines
    get "/everything", PageController, :everything
    get "/coaching", PageController, :coaching
    get "/post-relapse-academy", PageController, :post_relapse_academy
    get "/emergency", PageController, :emergency
    get "/neverfap-deluxe-league", PageController, :neverfap_deluxe_league
    
    get "/apple_podcast.xml", PageController, :apple_podcast_xml

    get "/articles", ContentController, :articles
    get "/articles/:slug", ContentController, :article
    get "/practices", ContentController, :practices
    get "/practices/:slug", ContentController, :practice
    get "/courses", ContentController, :courses
    get "/courses/:slug", ContentController, :course
    get "/podcast", ContentController, :podcasts
    get "/podcast/:slug", ContentController, :podcast
    get "/quotes", ContentController, :quotes
    get "/quotes/:slug", ContentController, :quote
    get "/meditation", ContentController, :meditations
    get "/meditation/:slug", ContentController, :meditation

    get "/seven-day-neverfap-deluxe-kickstarter", ContentEmailController, :seven_day_kickstarter
    get "/seven-day-neverfap-deluxe-kickstarter/:day", ContentEmailController, :seven_day_kickstarter_single
    get "/twenty-eight-day-awareness-challenge", ContentEmailController, :twenty_eight_day_awareness
    get "/twenty-eight-day-awareness-challenge/:day", ContentEmailController, :twenty_eight_day_awareness_single
    get "/ten-day-meditation-primer", ContentEmailController, :ten_day_meditation
    get "/ten-day-meditation-primer/:day", ContentEmailController, :ten_day_meditation_single
   end

  # Functions 
  scope "/", NfdWeb do
    pipe_through :browser

    # General functions
    post "/send_message", FunctionController, :contact_form_post
    get "/message_success", FunctionController, :send_message_success
    get "/message_failed", FunctionController, :send_message_failed
  
    # Subscription functions
    post "/confirm_subscription", SubscriptionController, :add_subscription_validate_matrix
    get "/subscription_success", SubscriptionController, :confirm_subscription_validate_matrix
    get "/unsubscribe", SubscriptionController, :unsubscribe_validate_matrix
    get "/change_subscription_dashboard_func", DashboardController, :change_subscription_dashboard_func
  end

  scope "/", NfdWeb do
    pipe_through [:browser, :protected]

    get "/dashboard", DashboardController, :dashboard
    get "/dashboard/profile", DashboardController, :profile
    get "/dashboard/delete_profile", DashboardController, :profile_delete_confirmation

    get "/dashboard/audio_courses", DashboardController, :audio_courses
    get "/dashboard/audio_courses/:collection", DashboardController, :audio_courses_collection
    get "/dashboard/audio_courses/:collection/:file", DashboardController, :audio_courses_single

    get "/dashboard/email_campaigns", DashboardController, :email_campaigns
    get "/dashboard/email_campaigns/:collection", DashboardController, :email_campaigns_collection
    get "/dashboard/email_campaigns/:collection/:file", DashboardController, :email_campaigns_single
  end

  scope "/dev" do
    pipe_through [:browser]
    forward "/mailbox", Plug.Swoosh.MailboxPreview, [base_path: "/dev/mailbox"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", NfdWeb do
  #   pipe_through :api
  # end
end
