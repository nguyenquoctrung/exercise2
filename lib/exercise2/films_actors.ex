defmodule Exercise2.FilmsActors do
  use Ecto.Schema
  import Ecto.Changeset

  schema "film_actors" do

    timestamps()
  end

  @doc false
  def changeset(films_actors, attrs) do
    films_actors
    |> cast(attrs, [])
    |> validate_required([])
  end
end
