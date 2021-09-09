defmodule Exercise2.Repo.Migrations.CreateFilmDirectors do
  use Ecto.Migration

  def change do
    create table(:film_directors) do
      # add :film_id, references(:films)
      # add :director_id, references(:directors)

      timestamps(default: fragment("NOW()"))
    end
    # create unique_index(:film_directors, [:film_id, :director_id])
  end
end
