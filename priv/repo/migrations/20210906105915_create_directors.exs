defmodule Exercise2.Repo.Migrations.CreateDirectors do
  use Ecto.Migration

  def change do
    create table(:directors) do
      add :name, :string

      timestamps(default: fragment("NOW()"))
    end

  end
end
