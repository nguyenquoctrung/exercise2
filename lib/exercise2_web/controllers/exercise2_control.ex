defmodule Exercise2Web.Exercise2Controller do
  use Exercise2Web, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, params) do
    title = get_in(params, ["search", "name"])
    country = get_in(params, ["search", "countries"])
    director = get_in(params, ["search", "directors"])

    page =
      Exercise2.Films
      |> Exercise2.Films.by_title(title)
      |> Exercise2.Films.released_country(country)
      |> Exercise2.Films.by_director(director)
      |> Film.Repo.paginate(params)

    data =
      page.entries
      |> Enum.map(fn x ->
        %{
          title: x.title,
          link: x.link,
          full_series: x.full_series,
          thumnail: x.thumnail,
          number_of_episode: x.number_of_episode,
          # years: x.years,
          # country: x.country,
          release_year: x.release_year,
          actors: x.actors,
          directors: x.directors
        }
      end)

    director = Exercise2Data.get_all_directors()

    list_directors =
      director
      |> Enum.map(fn x ->
        item = String.split(x, ",")

        if Enum.count(item) > 1 do
          item
          |> Enum.map(fn y ->
            %{name: String.trim(y)}
          end)
        else
          %{name: String.trim(x)}
        end
      end)
      |> List.flatten()
      |> Enum.uniq()

    country = Exercise2Data.get_all_countries()

    countries =
      country
      |> Enum.map(fn x -> String.split(x, ",") end)
      |> List.flatten()
      |> Enum.map(fn x ->
        item = String.split(x, ",")
        if Enum.count(item) > 1 do
          item
          |> Enum.map(fn y ->
            %{name: String.trim(y)}
          end)
        else
          %{name: String.trim(x)}
        end
      end)
      |> List.flatten()
      |> Enum.uniq()

    render(conn, "index.html",
      directors: list_directors,
      countries: countries,
      film: data,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      page: page
    )
  end
end
