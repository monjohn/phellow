defmodule Phellow.Content.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :position, :integer
    field :title, :string
    field :board_id, :id

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :position, :board_id])
    |> validate_required([:title])
  end
end
