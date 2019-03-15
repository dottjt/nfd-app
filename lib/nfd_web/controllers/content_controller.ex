defmodule NfdWeb.ContentController do
  use NfdWeb, :controller

  alias NfdWeb.API
  alias NfdWeb.API.Content

  alias Nfd.Meta

  plug :put_layout, "general.html"

  def articles(conn, _params) do
    page_type = "page"
    client = API.is_localhost(conn.host) |> API.api_client()

    case client |> Content.articles() do
      {:ok, response} ->
        Meta.increment_visit_count(response.body["data"])
        conn |> render("articles.html", item: response.body["data"], articles: response.body["data"]["articles"], page_type: page_type)
      {:error, _error} ->
        conn |> render(NfdWeb.ErrorView, "404.html")
    end
  end

  def article(conn, %{"slug" => slug}) do
    page_type = "content"
    client = API.is_localhost(conn.host) |> API.api_client()

    case client |> Content.article(slug) do
      {:ok, response} ->
        Meta.increment_visit_count(response.body["data"])
        if response.body["data"]["draft"] == false do 
          {:ok, articlesResponse} = client |> Content.articles()
          conn |> render("article.html", item: response.body["data"], articles: articlesResponse.body["data"]["articles"], page_type: page_type)  
        else 
          conn |> render(NfdWeb.ErrorView, "404.html")
        end
      {:error, _error} ->
        conn |> render(NfdWeb.ErrorView, "404.html")
    end
  end

  def practices(conn, _params) do
    page_type = "page"
    client = API.is_localhost(conn.host) |> API.api_client()

    case client |> Content.practices() do
      {:ok, response} ->
        Meta.increment_visit_count(response.body["data"])
        conn |> render("practices.html", item: response.body["data"], practices: response.body["data"]["practices"], page_type: page_type)
      {:error, _error} ->
        conn |> render(NfdWeb.ErrorView, "404.html")
    end
  end

  def practice(conn, %{"slug" => slug}) do
    page_type = "content"
    client = API.is_localhost(conn.host) |> API.api_client()

    case client |> Content.practice(slug) do
      {:ok, response} ->
        Meta.increment_visit_count(response.body["data"])
        if response.body["data"]["draft"] == false do 
          conn |> render("practice.html", item: response.body["data"], page_type: page_type)
        else
          conn |> render(NfdWeb.ErrorView, "404.html")
        end
      {:error, _error} ->
        conn |> render(NfdWeb.ErrorView, "404.html")
    end
  end

  def courses(conn, _params) do
    page_type = "page"
    client = API.is_localhost(conn.host) |> API.api_client()

    case client |> Content.courses() do
      {:ok, response} ->
        Meta.increment_visit_count(response.body["data"])
        conn |> render("courses.html", item: response.body["data"], courses: response.body["data"]["courses"], page_type: page_type)
      {:error, _error} ->
        conn |> render(NfdWeb.ErrorView, "404.html")
    end
  end

  def course(conn, %{"slug" => slug}) do
    page_type = "content"
    client = API.is_localhost(conn.host) |> API.api_client()

    case client |> Content.course(slug) do
      {:ok, response} ->
        Meta.increment_visit_count(response.body["data"])
        if response.body["data"]["draft"] == false do 
          conn |> render("course.html", item: response.body["data"], page_type: page_type)
        else
          conn |> render(NfdWeb.ErrorView, "404.html")
        end
      {:error, _error} ->
        conn |> render(NfdWeb.ErrorView, "404.html")
    end
  end

  def podcasts(conn, _params) do
    page_type = "page"
    client = API.is_localhost(conn.host) |> API.api_client()

    case client |> Content.podcasts() do
      {:ok, response} ->
        Meta.increment_visit_count(response.body["data"])
        conn |> render("podcasts.html", item: response.body["data"], podcasts: response.body["data"]["podcasts"], page_type: page_type)
      {:error, _error} ->
        conn |> render(NfdWeb.ErrorView, "404.html")
    end
  end

  def podcast(conn, %{"slug" => slug}) do
    page_type = "content"
    client = API.is_localhost(conn.host) |> API.api_client()

    case client |> Content.podcast(slug) do
      {:ok, response} ->
        Meta.increment_visit_count(response.body["data"])
        if response.body["data"]["draft"] == false do 
          conn |> render("podcast.html", item: response.body["data"], page_type: page_type)
        else 
          conn |> render(NfdWeb.ErrorView, "404.html")
        end
      {:error, _error} ->
        conn |> render(NfdWeb.ErrorView, "404.html")
    end
  end

  def quotes(conn, _params) do
    page_type = "page"
    client = API.is_localhost(conn.host) |> API.api_client()

    case client |> Content.quotes() do
      {:ok, response} ->
        Meta.increment_visit_count(response.body["data"])
        conn |> render("quotes.html", item: response.body["data"], item: response.body["data"]["quotes"], page_type: page_type)
      {:error, _error} ->
        conn |> render(NfdWeb.ErrorView, "404.html")
    end
  end

  def quote(conn, %{"slug" => slug}) do
    page_type = "content"
    client = API.is_localhost(conn.host) |> API.api_client()

    case client |> Content.quote(slug) do
      {:ok, response} ->
        Meta.increment_visit_count(response.body["data"])
        if response.body["data"]["draft"] == false do 
          conn |> render("quote.html", item: response.body["data"], page_type: page_type)
        else
          conn |> render(NfdWeb.ErrorView, "404.html")
        end
      {:error, _error} ->
        conn |> render(NfdWeb.ErrorView, "404.html")
    end
  end
end
