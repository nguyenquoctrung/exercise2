defmodule Exercise2.Repo.Migrations.CreateFilms do
  use Ecto.Migration

  def change do
    create table(:films) do
      add :title, :string
      add :link, :string
      add :full_series, :boolean, default: false, null: false
      add :number_of_episode, :integer
      add :thumnail, :string
      add :years, :integer

      timestamps(default: fragment("NOW()"))
    end

  end
end
