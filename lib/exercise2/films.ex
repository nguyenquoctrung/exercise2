defmodule Exercise2.Films do
  use Ecto.Schema
  import Ecto.Changeset

  schema "films" do
    field :full_series, :boolean, default: false
    field :link, :string
    field :number_of_episode, :integer
    field :thumnail, :string
    field :title, :string
    field :year, :integer

    timestamps()
  end

  @doc false
  def changeset(films, attrs) do
    films
    |> cast(attrs, [:title, :link, :full_series, :number_of_episode, :thumnail, :year])
    |> validate_required([:title, :link, :full_series, :number_of_episode, :thumnail, :year])
  end
end
