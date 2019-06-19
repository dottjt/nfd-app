defmodule NfdWeb.Fetch do
  use NfdWeb, :controller


  alias Nfd.Meta
  alias Nfd.Meta.Comment

  alias Nfd.API
  alias Nfd.API.Page
  alias Nfd.API.Content

  alias Nfd.Account
  alias Nfd.Account.Subscriber
  alias Nfd.Account.ContactForm

  alias NfdWeb.Redirects

  def fetch_content(conn, page_view, page_symbol, slug, page_layout, collection_array) do    
    user = Pow.Plug.current_user(conn) |> Account.get_user_pow!()

    content_specific_collection = fetch_collection_specific(user, page_symbol, slug)

    client = API.is_localhost(conn.host) |> API.api_client()
    verified_slug = Redirects.redirect_content(conn, slug, Atom.to_string(page_symbol))

    case apply(Content, page_symbol, [client, verified_slug]) do
      {:ok, response} ->
        collections = fetch_collections(response.body["data"], user, collection_array, client)
        fetch_response_ok(conn, user, page_view, response, collections, page_symbol, page_layout, "content")
      {:error, error} ->
        render_404_page(conn, error)
    end
  end

  def fetch_page(conn, page_view, page_symbol, page_layout, collection_array) do
    user = Pow.Plug.current_user(conn) |> Account.get_user_pow!()
    
    page_type = "page"
    client = API.is_localhost(conn.host) |> API.api_client()
    case apply(Page, page_symbol, [client]) do
      {:ok, response} ->
        collections = fetch_collections(response.body["data"], user, collection_array, client)
        fetch_response_ok(conn, user, page_view, response, collections, page_symbol, page_layout, page_type)
      {:error, error} -> render_404_page(conn, error)
    end
  end

  def fetch_response_ok(conn, user, page_view, response, collections, page_symbol, page_layout, page_type) do
    check_api_response_for_404(conn, response.status)
    Meta.increment_visit_count(response.body["data"])
    conn |> put_view(page_view) |> render("#{Atom.to_string(page_symbol)}.html", layout: { NfdWeb.LayoutView, page_layout }, item: response.body["data"], collections: collections, page_type: page_type, user: user)
  end

  def fetch_collections(item, user, collection_array, client) do
    Enum.reduce(
      collection_array,
      %{},
      fn x, acc ->
        case x do
          # COLLECTIONS
          :articles -> merge_collection(client, :articles, acc, item)
          :practices -> merge_collection(client, :practices, acc, item)
          :quotes -> merge_collection(client, :quotes, acc, item)
          :updates -> merge_collection(client, :updates, acc, item)
          :blogs -> merge_collection(client, :blogs, acc, item)
          :podcasts -> merge_collection(client, :podcasts, acc, item)
          :meditations -> merge_collection(client, :meditations, acc, item)
          :courses -> merge_collection(client, :courses, acc, item)

          :comments ->
            comments = Meta.list_collection_access_by_page_id(item["page_id"]) 
              |> Comment.organise_date()
              |> Comment.organise_comments()

            Map.put(acc, :comments, comments)

          # MESSAGE CHANGESETS
          :contact_form_changeset ->
            contact_form_changeset = ContactForm.changeset(%ContactForm{}, %{name: "", email: "", message: ""})
            Map.put(acc, :contact_form_changeset, contact_form_changeset)

          :comment_form_changeset ->
            id = if Map.has_key?(user, :id), do: user.id, else: ""
            name = if Map.has_key?(user, :first_name), do: "#{user.first_name} #{user.last_name}", else: ""
            email = if Map.has_key?(user, :email), do: user.email, else: ""
            comment_form_changeset = Comment.changeset(%Comment{}, %{name: name, email: email, message: "", parent_message_id: "", user_id: id, depth: 0, page_id: item["page_id"]})
            Map.put(acc, :comment_form_changeset, comment_form_changeset)

          # CONTENT EMAIL
          :seven_day_kickstarter -> acc |> fetch_content_email(client, :seven_day_kickstarter)
          :ten_day_meditation -> acc |> fetch_content_email(client, :ten_day_meditation)
          :twenty_eight_day_awareness -> acc |> fetch_content_email(client, :twenty_eight_day_awareness)
          :seven_week_awareness_vol_1 -> acc |> fetch_content_email(client, :seven_week_awareness_vol_1)
          :seven_week_awareness_vol_2 -> acc |> fetch_content_email(client, :seven_week_awareness_vol_2)
          :seven_week_awareness_vol_3 -> acc |> fetch_content_email(client, :seven_week_awareness_vol_3)
          :seven_week_awareness_vol_4 -> acc |> fetch_content_email(client, :seven_week_awareness_vol_4)

          :seven_day_kickstarter_changeset -> acc |> fetch_subscriber_changeset(:seven_day_kickstarter_changeset)
          :ten_day_meditation_changeset -> acc |> fetch_subscriber_changeset(:ten_day_meditation_changeset)
          :twenty_eight_day_awareness_changeset -> acc |> fetch_subscriber_changeset(:twenty_eight_day_awareness_changeset)
          :seven_week_awareness_vol_1_changeset -> acc |> fetch_subscriber_changeset(:seven_week_awareness_vol_1_changeset)
          :seven_week_awareness_vol_2_changeset -> acc |> fetch_subscriber_changeset(:seven_week_awareness_vol_2_changeset)
          :seven_week_awareness_vol_3_changeset -> acc |> fetch_subscriber_changeset(:seven_week_awareness_vol_3_changeset)
          :seven_week_awareness_vol_4_changeset -> acc |> fetch_subscriber_changeset(:seven_week_awareness_vol_4_changeset)
            
          _ ->
            acc
        end
      end)
  end

  defp fetch_collection_specific(user, page_symbol, slug) do 
    case page_symbol do
      :practice ->
        if user do
          # Get correct collection, based on slug, which would require looking at each file.
          ebook

        end
      # :article -> %{}
      # :course -> %{}
      # :podcast -> %{}
      # :quote -> %{}
      # :meditation -> %{}
      # :blog -> %{}
      # :update -> %{}
      _ -> %{}
    end
  end

  defp merge_collection(client, content_symbol, acc, item) do
    {:ok, response} = apply(Page, content_symbol, [client])
    collections = response.body["data"][Atom.to_string(content_symbol)] |> Enum.reverse()
    { previous_item, next_item } = Nfd.Meta.Page.previous_next_item(collections, item);
    Map.merge(acc, %{
      content_symbol => collections,
      next_item: next_item,
      previous_item: previous_item
    })
  end

  defp fetch_content_email(acc, client, symbol) do
    {:ok, response} = apply(Page, symbol, [client])
    data = response.body["data"]
    Map.put(acc, :seven_day_kickstarter, data)
  end

  defp fetch_subscriber_changeset(acc, symbol) do
    Map.put(acc, symbol, Subscriber.changeset(%Subscriber{}, %{}))
  end

  def render_404_page(conn, error) do
    IO.inspect error
    conn
      |> put_view(NfdWeb.ErrorView)
      |> render("404.html")
  end

  defp check_api_response_for_404(conn, status) do
    if status != 200, do: render_404_page(conn, status)
  end
end
