defmodule Exercise2Web.ExerciseController do
  use Exercise2Web, :controller
  @url "https://phephims.net/the-loai/phim-hoat-hinh"

  def index(conn, _params) do
    #Crawly.save_file(@url)
    # if File.exists?(@file_path) do
    #   File.write(@file_path, json)
    # else
    #   File.write(@file_path, :erlang.iolist_to_binary(json))
    # end
    render(conn, "index.html", data: %{items: [], total: 0, crawled: "",mess: ""})
  end

  # def import_file(conn, params) do
  #   if !is_nil(params["upload"]) do
  #     crawled_at = DateTime.now!("Etc/UTC")|>DateTime.to_string()|>String.slice(0..-9)
  #     path = params["upload"].path
  #     # kiểm tra đúng loại file k
  #     {:ok, data} = File.read(path)
  #     list_film = String.split(data, "\n")
  #     total= Enum.count(list_film)
  #     if total > 0 do
  #     #  res = Enum.reduce(list_film, fn x, acc -> [Crawly.fetch(x) | acc] end)
  #      res = Enum.map_every(list_film, 1, fn x -> Crawly.fetch(x) end)
  #      item=res|>List.flatten()
  #      totals= item|>Enum.count()
  #      render(conn, "index.html", data: %{items: item, total: totals, crawled: crawled_at,mess: ""})
  #     end
  #   end

  # end

end
