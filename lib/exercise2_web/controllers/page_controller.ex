defmodule Exercise2Web.PageController do
  use Exercise2Web, :controller
  @url_default "https://phephims.net/"
  def index(conn, params) do
   # CategoryData.insert_category()
    url = get_in(params, ["query"])
    totals=0
    items=%{}
    crawled_at = DateTime.now!("Etc/UTC")|>DateTime.to_string()|>String.slice(0..-9)
    if url != nil do
      if String.contains?(url, @url_default) do
        items=Crawly.fetch(url)
        totals= Enum.count(items)
        render(conn, "index.html", data: %{items: items, total: totals, crawled: crawled_at,mess: "", page: nil})
      end
    end
      render(conn, "index.html", data: %{items: items, total: totals, crawled: crawled_at,mess: "", page: nil})
  end

  @spec save_file(Plug.Conn.t(), any) :: Plug.Conn.t()
  def save_file(conn, params) do
    url = get_in(params, ["url"])
    name_file=Crawly.save_file(url)
   case name_file do
    nil -> render(conn, "index.html", data: %{items: [], total: 0, crawled: "" , mess: "Error", page: nil})
    _-> render(conn, "index.html", data: %{items: [], total: 0, crawled: "" , mess: "Export file successfully! File name:"<>name_file<>"!", page: nil})
   end
  end
  def import_file(conn, params) do
    if !is_nil(params["upload"]) do
      crawled_at = DateTime.now!("Etc/UTC")|>DateTime.to_string()|>String.slice(0..-9)
      path = params["upload"].path
      # kiểm tra đúng loại file k
      {:ok, data} = File.read(path)
      list_film = String.split(data, "\n")
      total= Enum.count(list_film)
      if total > 0 do
      #  res = Enum.reduce(list_film, fn x, acc -> [Crawly.fetch(x) | acc] end)
       res = Enum.map_every(list_film, 1, fn x -> Crawly.fetch(x) end)
       item=res|>List.flatten()
       totals= item|>Enum.count()
       render(conn, "index.html", data: %{items: item, total: totals, crawled: crawled_at,mess: "", page: nil})
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
    crawled_at = DateTime.now!("Etc/UTC")|>DateTime.to_string()|>String.slice(0..-9)
    if url != nil do

      pages =
      case Map.has_key?(params, "page") do
        false -> 1
        true -> {:ok,page}= Map.fetch(params,"page")
              page|>String.to_integer()
      end
      config =  %Scrivener.Config{page_number: pages, page_size: 20}
      items=Crawly.fetch_number(url,number)
      #totals= Enum.count(items)
      page=items|>Scrivener.paginate(config)
      render(conn, "index.html", data: %{items: page.entries, total: page.total_entries, crawled: crawled_at,mess: "", page: page})
    else
      render(conn, "index.html", data: %{items: [], total: 0, crawled: crawled_at,mess: "URL is null", page: nil})
    end
  end

  def save_database(conn, params) do
    url = get_in(params, ["url"])
    crawled_at = DateTime.now!("Etc/UTC")|>DateTime.to_string()|>String.slice(0..-9)
    if url != nil do
      items = Crawly.fetch(url)
      # raise items
      total= Enum.count(items)
      if total >0 do
        Exercise2Data.insert_film(items)
      end
      render(conn, "index.html", data: %{items: items, total: total, crawled: crawled_at,mess: "Update database successfully", page: nil})
    else
      render(conn, "index.html", data: %{items: [], total: 0, crawled: crawled_at,mess: "URL is null", page: nil})
    end
  end

end
