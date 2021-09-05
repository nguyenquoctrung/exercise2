defmodule Exercise2.Films do
  use Ecto.Schema
  import Ecto.Changeset

  schema "films" do
    field :full_series, :boolean, default: false
    field :link, :string
    field :thumnail, :string
    field :number_of_episode, :integer
    field :title, :string
    field :years, :integer

    timestamps()
  end

  @doc false
  def changeset(films, attrs) do
    films
    |> cast(attrs, [:title, :link, :full_series, :thumnail,:number_of_episode,  :years])
    |> validate_required([:title, :link, :full_series, :thumnail, :number_of_episode, :years])
  end
end
