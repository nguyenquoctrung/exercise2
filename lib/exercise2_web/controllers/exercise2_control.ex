defmodule Exercise2Web.Exercise2Controller do
  use Exercise2Web, :controller
  @url "https://phephims.net/the-loai/phim-hoat-hinh"
  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    items = Crawly.fetch(@url)
    total=Enum.count(items)
    crawled_at=DateTime.now!("Etc/UTC")|>DateTime.to_string()|>String.slice(0..-9)
    render(conn, "index.html", data: %{items: items, total: total, crawled_at: crawled_at })
  end
end
