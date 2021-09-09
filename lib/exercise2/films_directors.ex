defmodule Exercise2.FilmsDirectors do
  use Ecto.Schema
  import Ecto.Changeset

  schema "film_directors" do

    timestamps()
  end

  @doc false
  def changeset(films_directors, attrs) do
    films_directors
    |> cast(attrs, [])
    |> validate_required([])
  end
end
