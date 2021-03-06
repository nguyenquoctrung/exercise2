defmodule Exercise2Data do
  import Ecto.Query
  alias Exercise2.{Repo, Actors, Films, Directors}

  @spec insert_film(any) :: none
  def insert_film(data) do
    Repo.insert_all(Films, data)
  end

  # Films

  @spec creat_films(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          any
  def creat_films(params) do
    # %Films{}
    # |> Films.changeset(attrs)
    # |> Repo.insert()

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:record_1, Films.changeset(%Films{}, params))
    |> Ecto.Multi.insert(:record_2, Directors.changeset(%Directors{}, params))
    |> Repo.transaction()
  end


  def list_films() do
    Repo.all(Films)
  end

  def get_films_name(name) do
    Repo.get_by(Films, name)
  end

  def fetch_or_create_film(fetch_by, attrs) do
    with nil <- get_film_by(fetch_by),
         {:ok, film} <- create_film(attrs) do
      {:ok, film}
    else
      %Films{} = film ->
        {:ok, film}

      {:error, %Ecto.Changeset{} = changeset} ->
        if changeset.errors[:my_unique_field] == {"has already been taken", []} do
          fetch_or_create_film(fetch_by, attrs)
        else
          {:error, changeset}
          raise attrs
        end
    end
  end

  def get_film_by(by) do
    Repo.get_by(Films, title: by)
  end

  def create_film(attrs) do
    %Films{}
    |> Films.changeset(attrs)
    |> Repo.insert()
  end



  # actors
  def create_actors(attrs) do
    %Actors{}
    |> Actors.changeset(attrs)
    |> Repo.insert()
  end

  # directors
  def create_directors(name) do
    director = %{name: name}

    %Directors{}
    |> Directors.changeset(director)
    |> Repo.insert()
  end

  def directors_by_name(name) do
    Repo.get_by(Directors, name: name)
  end

  def get_all_directors() do
    query =
      from(u in "films",
        distinct: true,
        order_by: u.directors,
        select: u.directors
      )
    Repo.all(query)
  end

  def get_all_countries() do
    query =
      from(u in "films",
        distinct: true,
        order_by: u.country,
        select: u.country
      )
    Repo.all(query)
  end
end
