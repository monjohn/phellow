defmodule Phellow.Content.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :description, :string
    field :title, :string
    belongs_to :list, Phellow.Content.List

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :description, :list_id])
    |> validate_required([:title, :list_id])
    |> foreign_key_constraint(:list_id)
  end
end
