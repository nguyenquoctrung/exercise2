defmodule Exercise2Web.Exercise2Controller do
  use Exercise2Web, :controller
  @url "https://phephims.net/danh-sach/phim-bo-hong-kong"
  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, params) do

    pages =
    case Map.has_key?(params, "page") do
      false -> 1
      true -> {:ok,page}= Map.fetch(params,"page")
            page|>String.to_integer()
    end
    config =  %Scrivener.Config{page_number: pages, page_size: 20}
    page = Crawly.fetch(@url)|>Scrivener.paginate(config)
    render(conn, "index.html",
          film: page.entries,
          page_number: page.page_number,
          page_size: page.page_size,
          total_pages: page.total_pages,
          total_entries: page.total_entries,
          page: page)
  end
end
