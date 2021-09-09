defmodule Exercise2.Actors do
  use Ecto.Schema
  import Ecto.Changeset

  schema "actors" do
    field :name, :string

    # many_to_many :films, Exercise2.Films, join_through: "films_actors"
    timestamps()
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :name,
  ]

  @doc false
  def changeset(actors, attrs) do
    actors
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
end
