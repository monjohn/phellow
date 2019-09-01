defmodule PhellowWeb.BoardsLive do
  use Phoenix.LiveView
  alias Phellow.Content

  def render(assigns) do
    PhellowWeb.BoardView.render("board.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, assign(socket, lists: lists_for_board(1), show_card_composer: 0)}
  end

  def handle_event("add_list", %{"list" => %{"title" => title}}, socket) do
    Content.create_list(%{title: title, board_id: 1})

    {:noreply, assign(socket, lists: lists_for_board(1))}
  end

  def handle_event("add_card", %{"card" => %{"title" => title, "list_id" => list_id}}, socket) do
    Content.create_card(%{title: title, list_id: list_id})

    {:noreply, assign(socket, lists: lists_for_board(1), show_card_composer: 0)}
  end

  def handle_event("show_card_composer", %{"list_id" => list_id}, socket) do
    {:noreply, assign(socket, show_card_composer: String.to_integer(list_id))}
  end

  def handle_event(event, params, socket) do
    IO.puts(event)
    IO.inspect(params)

    {:noreply, assign(socket, lists: lists_for_board(1))}
  end

  def lists_for_board(_id) do
    Content.board_lists(1)
  end

  def find_lists do
    [
      %{title: "In Progress", id: 2, position: 1},
      %{title: "Upcoming", id: 1, position: 0},
      %{title: "Done", id: 3, position: 2}
    ]
    |> Enum.sort_by(&Map.fetch(&1, :position))
  end
end
