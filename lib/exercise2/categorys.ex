defmodule Exercise2.Categorys do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categorys" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(categorys, attrs) do
    categorys
    |> cast(attrs, [:name])
    |> validate_required([:name])
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
