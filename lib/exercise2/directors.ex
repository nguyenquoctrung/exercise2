defmodule Exercise2.Directors do
  use Ecto.Schema
  import Ecto.Changeset

  schema "directors" do
    field :name, :string
    # many_to_many :films, Exercise2.Actors, join_through: "films_directors"
    timestamps()
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :name
  ]
  @doc false
  def changeset(films, attrs) do
    films
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
  @doc false
  def changeset(directors, attrs) do
    directors
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
end
