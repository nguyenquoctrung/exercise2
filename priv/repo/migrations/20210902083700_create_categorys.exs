defmodule Exercise2.Repo.Migrations.CreateCategorys do
  use Ecto.Migration

  def change do
    create table(:categorys) do
      add :name, :string

      timestamps(default: fragment("NOW()"))
    end

  end
end
