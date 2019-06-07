defmodule NfdWeb.PageController do
  use NfdWeb, :controller

  alias NfdWeb.Fetch
  alias NfdWeb.FetchCollection

  # GENERAL
  def home(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :home, "home.html", FetchCollection.fetch_collections_array(:home))
  def about(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :about, "general.html", FetchCollection.fetch_collections_array(:about))
  def contact(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :contact, "general.html", FetchCollection.fetch_collections_array(:contact))
  def community(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :community, "general.html", FetchCollection.fetch_collections_array(:community))
  def donations(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :donations, "general.html", FetchCollection.fetch_collections_array(:donations))
  def everything(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :everything, "general.html", FetchCollection.fetch_collections_array(:everything))

  # GUIDES
  def guide(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :guide, "general.html", FetchCollection.fetch_collections_array(:guide))
  def summary(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :summary, "general.html", FetchCollection.fetch_collections_array(:summary))
  def neverfap_deluxe_bible(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :neverfap_deluxe_bible, "general.html", FetchCollection.fetch_collections_array(:neverfap_deluxe_bible))
  def emergency(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :emergency, "home.html", FetchCollection.fetch_collections_array(:emergency))
  def post_relapse_academy(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :post_relapse_academy, "home.html", FetchCollection.fetch_collections_array(:post_relapse_academy))

  # LEGAL
  def disclaimer(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :disclaimer, "general.html", FetchCollection.fetch_collections_array(:disclaimer))
  def privacy(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :privacy, "general.html", FetchCollection.fetch_collections_array(:privacy))
  def terms_and_conditions(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :terms_and_conditions, "general.html", FetchCollection.fetch_collections_array(:terms_and_conditions))

  # PROGRAMS
  def accountability(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :accountability, "general.html", FetchCollection.fetch_collections_array(:accountability))
  def reddit_guidelines(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :reddit_guidelines, "general.html", FetchCollection.fetch_collections_array(:reddit_guidelines))
  def coaching(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :coaching, "general.html", FetchCollection.fetch_collections_array(:coaching))

  # VOLUNTEER
  def helpful_neverfap_counsel(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :helpful_neverfap_counsel, "general.html", FetchCollection.fetch_collections_array(:helpful_neverfap_counsel))
  def engineering_corps(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :engineering_corps, "general.html", FetchCollection.fetch_collections_array(:engineering_corps))
  def marketing_department(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :marketing_department, "general.html", FetchCollection.fetch_collections_array(:marketing_department))

  # APPS
  def desktop_app(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :desktop_app, "general.html", FetchCollection.fetch_collections_array(:desktop_app))
  def mobile_app(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :mobile_app, "general.html", FetchCollection.fetch_collections_array(:mobile_app))
  def chrome_extension(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :chrome_extension, "general.html", FetchCollection.fetch_collections_array(:chrome_extension))
  def open_source(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :open_source, "general.html", FetchCollection.fetch_collections_array(:open_source))
  def neverfap_deluxe_league(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :neverfap_deluxe_league, "general.html", FetchCollection.fetch_collections_array(:neverfap_deluxe_league))

  # MISC
  def never_fap(conn, _params), do: Fetch.fetch_page(conn, NfdWeb.PageView, :never_fap, "general.html", FetchCollection.fetch_collections_array(:never_fap))

  # Images
  def test(conn, _params), do: conn |> render("test.html")
  def season_one(conn, _params), do: conn |> render("season_one.html")
  def season_two(conn, _params), do: conn |> render("season_two.html")

  def apple_podcast_xml(conn, _params) do
    client = API.is_localhost(conn.host) |> API.api_client()

    case Tesla.get(client, "http://rss.castbox.fm/everest/aab82e46f0cd4791b1c8ddc19d5158c3.xml") do
      {:ok, response} ->
        regex = ~r/https:\/\/s3.castbox.fm(\/*[a-zA-Z0-9])*.png/
        # does_match = Regex.match?(regex, "https://s3.castbox.fm/89/8f/d7/ab55544abb81506d8240808921.png") |> IO.inspect
        new_xml =
          Regex.replace(
            regex,
            response.body,
            "https://neverfapdeluxe.com/images/logo_podcast.png",
            global: true
          )

        conn
        |> put_resp_content_type("text/xml")
        |> send_resp(200, new_xml)

      {:error, error} ->
        Fetch.render_404_page(conn, error)
    end
  end
end
