defmodule Exercise2Web.ExerciseController do
  use Exercise2Web, :controller
  @url "https://phephims.net/the-loai/phim-hoat-hinh?page="

  def index(conn, _params) do
    Crawly.save_file(@url)

    # if File.exists?(@file_path) do
    #   File.write(@file_path, json)
    # else
    #   File.write(@file_path, :erlang.iolist_to_binary(json))
    # end
    render(conn, "index.html")
  end
end
