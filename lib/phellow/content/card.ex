defmodule Phellow.Content.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :description, :string
    field :title, :string
    field :position, :integer
    belongs_to :list, Phellow.Content.List

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :description, :list_id, :position])
    |> validate_required([:title, :list_id])
    |> foreign_key_constraint(:list_id)
  end
end
