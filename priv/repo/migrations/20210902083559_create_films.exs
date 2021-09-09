defmodule Exercise2.Repo.Migrations.CreateFilms do
  use Ecto.Migration

  def change do
    create table(:films) do
      add :title, :text
      add :link, :text
      add :full_series, :boolean, default: false, null: false
      add :number_of_episode, :integer
      add :thumnail, :text
      # add :years, :integer
      add :country, :string
      add :release_year, :string
      add :actors, :string
      add :directors, :string

      timestamps(default: fragment("NOW()"))
    end

  end
end
