defmodule Exercise2Web.PageController do
  use Exercise2Web, :controller
  @url "https://phephims.net/the-loai/phim-hoat-hinh?page="
  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    items = Crawly.fetch(@url)
    render(conn, "index.html", data: items)
  end
end
