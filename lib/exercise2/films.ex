defmodule Exercise2.Films do
  use Ecto.Schema
  import Ecto
  import Ecto.Changeset
  import Ecto.Query


  schema "films" do
    field(:title, :string)
    field(:link, :string)
    field(:full_series, :boolean, default: false)
    field(:thumnail, :string)
    field(:number_of_episode, :integer)
    # field :years, :integer
    field(:country, :string)
    field(:release_year, :string)
    field(:actors, :string)
    field(:directors, :string)
    # # has_many :characters, Friends.Character
    # # has_one :distributor, Friends.Distributor
    # many_to_many :actors, Exercise2.Actors, join_through: "films_actors"
    # many_to_many :directors, Exercise2.Directors, join_through: "films_directors"
    timestamps()
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :title,
    :link,
    :full_series,
    :thumnail,
    :number_of_episode,
    # :years,
    :country,
    :release_year,
    :actors,
    :directors
  ]
  @doc false
  def changeset(films, attrs) do
    films
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:title])
  end

  def released_country(query, country) when is_nil(country) or byte_size(country) == 0 do
    query
  end

  def released_country(query, country) do
    like = "%#{country}%"
    from films in query,
    where: like(films.country, ^like)
  end
  def by_director(query, director) when is_nil(director) or byte_size(director) == 0 do
    query
  end
  def by_director(query, director) do
    from films in query,
    where: films.directors == ^director
  end

  def by_title(query, title) when is_nil(title) or byte_size(title) == 0 do
    query
  end

  def by_title(query, title) do
    like = "%#{title}%"
    from films in query,
    where: like(films.title, ^like)
  end


  # @default_fields [
  #   :id,
  #   :inserted_at,
  #   :updated_at
  # ]
  # @required_fields []

  # def changeset(category, attrs) do
  #   category
  #   |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
  #   |> validate_required(@required_fields)
  #   |> cast_assoc(:items)
  # end
end
