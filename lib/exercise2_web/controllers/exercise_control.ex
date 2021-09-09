defmodule Exercise2Web.ExerciseController do
  use Exercise2Web, :controller
  @url "https://mphimmoi.net/quoc-gia/an-do.html"

  def index(conn, _params) do
    list_film = Crawly.fetch_all(@url)
    # data_film = Exercise2Data.list_films()
    # data =
    #   data_film
    #   |> Enum.map(fn x ->
    #     %{
    #       title: x.title,
    #       link: x.link,
    #       full_series: x.full_series,
    #       thumnail: x.thumnail,
    #       number_of_episode: x.number_of_episode,
    #       #years: x.years,
    #       # country: x.country,
    #       release_year: x.release_year,
    #       actors: x.actors,
    #       directors: x.directors
    #     }
    #   end)

    # res = list_film -- data

    list_film|> Enum.map(fn x ->
        Exercise2Data.fetch_or_create_film(x.title,x)
    end)




    # raise data_film
    # list_film_not_exist= Enum.filter(list_film, fn el -> !Enum.member?(data_film, el) end)

    # list_film_not_exist|>Enum.map(fn dis ->

    # data= Exercise2Data.create_film(dis)

    # end)

    # list_film
    # |> Enum.map(fn item ->
    #   if byte_size(item.directors) > 0 do
    #     # lưu thông tin đạo diễn
    #     # list_directors=item.directors|>String.split(",")|>Enum.map(fn x -> %{name: x} end)|>Enum.at(0)
    #     list_directors = item.directors |> String.split(",")

    #     data=
    #     list_directors
    #     |> Enum.map(fn dis ->
    #       check_director = Exercise2Data.directors_by_name(dis)

    #       if check_director == nil do
    #         director = Exercise2Data.create_directors(dis)

    #         if director == nil do
    #           %{director_id: 0}
    #         else
    #           raise director.id
    #           %{director_id: director.id}
    #         end

    #       else
    #         %{director_id: check_director.id}
    #       end

    #     end)
    #     raise data
    #   else
    #     0
    #   end

    # end)

    #   {:ok, films} =
    #   Exercise2Data.create_film(%{
    #     full_series: true,
    #     link: "url update",
    #     thumnail: "Hinh",
    #     number_of_episode: 23,
    #     title: "Phim Hoạ Bì",
    #     years: 2021,
    #     country: "Trung Quốc",
    #     release_year: 2008,
    #     actors: "ABC",
    #     directors: "Vũ Trọng"
    #   })

    # raise films.id

    render(conn, "index.html")
  end
end
