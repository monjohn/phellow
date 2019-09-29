defmodule Phellow.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias Phellow.Repo

  alias Phellow.Content.Board
  alias Phellow.Content.List

  def list_boards do
    Repo.all(Board)
  end

  def get_board!(id), do: Repo.get!(Board, id)

  def create_board(attrs \\ %{}) do
    %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()
  end

  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  def change_board(%Board{} = board) do
    Board.changeset(board, %{})
  end

  alias Phellow.Content.List

  def list_lists do
    Repo.all(List)
  end

  def lists_for_board(id) do
    query =
      from List,
        where: [board_id: ^id],
        order_by: [asc: :position],
        preload: [:cards],
        select: [:id, :title, :board_id, :position]

    Repo.all(query)
  end

  def get_list!(id), do: Repo.get!(List, id)

  def create_list(attrs \\ %{}) do
    with_position =
      case attrs do
        %{position: _} ->
          attrs

        _ ->
          Map.put(attrs, "position", next_list_position())
      end

    %List{}
    |> List.changeset(with_position)
    |> Repo.insert()
  end

  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  def next_list_position do
    result =
      from(list in List, select: max(list.position))
      |> Repo.one()

    case result do
      nil -> 0
      int -> int + 1
    end
  end

  def change_list(%List{} = list) do
    List.changeset(list, %{})
  end

  alias Phellow.Content.Card

  def reorder_lists(start, the_end) when is_binary(start) or is_binary(the_end) do
    raise "reorder_lists takes integers"
  end

  def reorder_lists(start, the_end) when start < the_end do
    from(l in List,
      where: ^start < l.position and l.position <= ^the_end,
      update: [inc: [position: -1]]
    )
    |> Repo.update_all([])
  end

  def reorder_lists(start, the_end) do
    from(l in List,
      where: ^the_end <= l.position and l.position < ^start,
      update: [inc: [position: 1]]
    )
    |> Repo.update_all([])
  end

  def cards_for_list(id) do
    q =
      from Card,
        where: [list_id: ^id],
        order_by: [asc: :position],
        select: [:id, :title, :description]

    Repo.all(q)
  end

  def move_card_to_list(card_id, to_list, to_position) do
    card = get_card!(card_id)
    placeholder = %Card{card | position: to_position}

    Phellow.Repo.transaction(fn ->
      reorder_list_after_removing_card(card)
      reorder_list_after_adding_card(placeholder)
      update_card(card, %{position: to_position, list_id: to_list})
    end)
  end

  def reorder_list_after_adding_card(%Card{list_id: list_id, position: position}) do
    from(c in Card,
      where: ^position < c.position and c.list_id == ^list_id,
      update: [inc: [position: 1]]
    )
    |> Repo.update_all([])
  end

  def reorder_list_after_removing_card(%Card{list_id: list_id, position: position}) do
    from(c in Card,
      where: ^position < c.position and c.list_id == ^list_id,
      update: [inc: [position: -1]]
    )
    |> Repo.update_all([])
  end

  def get_card!(id), do: Repo.get!(Card, id)

  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  def change_card(%Card{} = card) do
    Card.changeset(card, %{})
  end
end
