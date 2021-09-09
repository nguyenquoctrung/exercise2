defmodule Exercise2Web.PageController do
  use Exercise2Web, :controller
  @url_default "https://mphimmoi.net/"
  def index(conn, params) do
    url = get_in(params, ["query"])
    crawled_at = DateTime.now!("Etc/UTC") |> DateTime.to_string() |> String.slice(0..-9)

    if url != nil do
      if String.contains?(url, @url_default) do
        items = Crawly.fetch(url)
        totals = Enum.count(items)

        render(conn, "index.html",
          data: %{items: items, total: totals, crawled: crawled_at, mess: "", page: nil}
        )
      else
        render(conn, "index.html",
          data: %{items: nil, total: 0, crawled: crawled_at, mess: "URL is null", page: nil}
        )
      end
    end

    render(conn, "index.html",
      data: %{items: nil, total: 0, crawled: crawled_at, mess: "", page: nil}
    )
  end

  @spec save_file(Plug.Conn.t(), any) :: Plug.Conn.t()
  def save_file(conn, params) do
    url = get_in(params, ["url"])
    name_file = Crawly.save_file(url)

    if name_file == nil do
      render(conn, "index.html",
        data: %{items: [], total: 0, crawled: "", mess: "Error", page: nil}
      )
    else
      render(conn, "index.html",
        data: %{
          items: [],
          total: 0,
          crawled: "",
          mess: "Export file successfully! File name:" <> name_file <> "!",
          page: nil
        }
      )
    end
  end

  def import_file(conn, params) do
    if !is_nil(params["upload"]) do
      crawled_at = DateTime.now!("Etc/UTC") |> DateTime.to_string() |> String.slice(0..-9)
      path = params["upload"].path
      # kiểm tra đúng loại file k
      {:ok, data} = File.read(path)
      list_film = String.split(data, "\n")
      total = Enum.count(list_film)

      if total > 0 do
        #  res = Enum.reduce(list_film, fn x, acc -> [Crawly.fetch(x) | acc] end)
        res = Enum.map_every(list_film, 1, fn x -> Crawly.fetch(x) end)
        item = res |> List.flatten()
        totals = item |> Enum.count()

        render(conn, "index.html",
          data: %{items: item, total: totals, crawled: crawled_at, mess: "", page: nil}
        )
        else
          render(conn, "index.html",
          data: %{items: nil, total: 0, crawled: crawled_at, mess: "", page: nil}
        )
      end
    end
  end

  # def fetch_number(conn, params) do
  #   url = get_in(params, ["url"])
  #   number = get_in(params, ["number"])
  #   crawled_at = DateTime.now!("Etc/UTC")|>DateTime.to_string()|>String.slice(0..-9)
  #   if url != nil do
  #     items=Crawly.fetch_number(url,number)
  #     totals= Enum.count(items)
  #     render(conn, "index.html", data: %{items: items, total: totals, crawled: crawled_at,mess: ""})
  #   else
  #     render(conn, "index.html", data: %{items: [], total: 0, crawled: crawled_at,mess: "URL is null"})
  #   end

  # end

  def fetch_number(conn, params) do
    url = get_in(params, ["url"])
    number = get_in(params, ["number"])
    crawled_at = DateTime.now!("Etc/UTC") |> DateTime.to_string() |> String.slice(0..-9)
    if url != nil do
      #pages = get_in(params, ["page"])|> String.to_integer()
        # if Map.has_key?(params, "page") do
        #     1
        #   else
        #     {:ok, page} = Map.fetch(params, "page")
        #     page |> String.to_integer()
        # end

      config = %Scrivener.Config{page_number: 1, page_size: 20}
      items = Crawly.fetch_number(url, number)
      # totals= Enum.count(items)
      page = items |> Scrivener.paginate(config)

      render(conn, "index.html",
        data: %{
          items: page.entries,
          total: page.total_entries,
          crawled: crawled_at,
          mess: "",
          page: page
        }
      )
    else
      render(conn, "index.html",
        data: %{items: [], total: 0, crawled: crawled_at, mess: "URL is null", page: nil}
      )
    end
  end

  def save_database(conn, params) do
    url = get_in(params, ["url"])
    crawled_at = DateTime.now!("Etc/UTC") |> DateTime.to_string() |> String.slice(0..-9)

    if url != nil do
       data_film=Exercise2.Films|>Film.Repo.all()
       list_film_data = data_film|>Enum.map(fn x ->
        %{
          title: x.title,
          link: x.link,
          full_series: x.full_series,
          thumnail: x.thumnail,
          number_of_episode: x.number_of_episode,
          # years: x.years,
          country: x.country,
          release_year: x.release_year,
          actors: x.actors,
          directors: x.directors
        }
      end)

      items = Crawly.fetch_all(url)
      new_items= items -- list_film_data
      total = Enum.count(new_items)
      Enum.map(new_items,fn x ->
        #Exercise2Data.fetch_or_create_film(x.title,x)
        Exercise2Data.create_film(x)
       end)
      # if total > 0 do
      #   Exercise2Data.insert_film(items)
      # end

      render(conn, "index.html",
        data: %{
          items: new_items,
          total: total,
          crawled: crawled_at,
          mess: "Total #{total} films added successfully",
          page: nil
        }
      )
    else
      render(conn, "index.html",
        data: %{items: [], total: 0, crawled: crawled_at, mess: "URL is null", page: nil}
      )
    end
  end
end
