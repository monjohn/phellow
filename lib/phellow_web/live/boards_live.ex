defmodule PhellowWeb.BoardsLive do
  use Phoenix.LiveView
  alias Phellow.Content

  def render(assigns) do
    PhellowWeb.BoardView.render("board.html", assigns)
  end

  def mount(_session, socket) do
    {:ok,
     assign(socket, lists: lists_for_board(1), show_card_composer: 0, show_list_composer: false)}
  end

  def handle_event("show_list_composer", %{"should_show" => value}, socket) do
    case value do
      "true" -> {:noreply, assign(socket, show_list_composer: true)}
      "false" -> {:noreply, assign(socket, show_list_composer: false)}
    end
  end

  def handle_event("add_list", %{"list" => %{"title" => title}}, socket) do
    Content.create_list(%{"title" => title, "board_id" => 1})

    {:noreply, assign(socket, lists: lists_for_board(1))}
  end

  def handle_event("reorder_list", %{"list_id" => list_id, "to_position" => to_position}, socket) do
    list = Content.get_list!(list_id)

    Phellow.Repo.transaction(fn ->
      Content.reorder_lists(list.position, to_position)
      Content.update_list(list, %{position: to_position})
    end)

    {:noreply, assign(socket, lists: lists_for_board(1))}
  end

  def handle_event("move_card", params, socket) do
    %{
      "to_list" => to_list,
      "to_position" => to_position,
      "card_id" => card_id
    } = params

    Content.move_card_to_list(card_id, to_list, to_position)

    {:noreply, assign(socket, lists: lists_for_board(1))}
  end

  def handle_event("add_card", %{"card" => %{"title" => title, "list_id" => list_id}}, socket) do
    Content.create_card(%{"title" => title, "list_id" => list_id})

    {:noreply, assign(socket, lists: lists_for_board(1), show_card_composer: 0)}
  end

  def handle_event("show_card_composer", %{"list_id" => list_id}, socket) do
    {:noreply, assign(socket, show_card_composer: String.to_integer(list_id))}
  end

  # For debugging purposes
  def handle_event(event, params, socket) do
    IO.puts(event)
    IO.inspect(params)

    {:noreply, assign(socket, lists: lists_for_board(1))}
  end

  def lists_for_board(_id) do
    Content.board_lists(1)
  end
end
