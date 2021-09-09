defmodule Exercise2.Repo.Migrations.CreateActors do
  use Ecto.Migration

  def change do
    create table(:actors) do
      add :name, :string

      timestamps(default: fragment("NOW()"))
    end

  end
end
