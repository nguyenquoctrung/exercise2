defmodule Exercise2.Repo.Migrations.CreateFilmActors do
  use Ecto.Migration

  def change do
    create table(:film_actors) do
      # add :film_id, references(:films)
      # add :actor_id, references(:actors)

      timestamps(default: fragment("NOW()"))
    end

    # create unique_index(:film_actors, [:film_id, :actor_id])
  end
end
