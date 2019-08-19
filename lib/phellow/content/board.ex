defmodule Phellow.Content.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :img_url, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:title, :img_url])
    |> validate_required([:title, :img_url])
  end
end
