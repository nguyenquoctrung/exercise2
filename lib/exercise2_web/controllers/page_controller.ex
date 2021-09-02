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
        render(conn, "index.html", data: %{items: items, total: totals, crawled: crawled_at})
      end
    end
      render(conn, "index.html", data: %{items: items, total: totals, crawled: crawled_at})
  end
end
