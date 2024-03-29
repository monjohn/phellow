defmodule PhellowWeb.BoardsLive do
  use Phoenix.LiveView
  alias Phellow.Content
  alias Phellow.Content.Card

  @topic "board_updates"

  def render(assigns) do
    PhellowWeb.BoardView.render("board.html", assigns)
  end

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Phellow.PubSub, @topic)

    current_board = Content.get_board!(1)

    {:ok,
     assign(socket,
       lists: Content.lists_for_board(1),
       current_board: current_board,
       boards: boards_to_select(current_board),
       show_boards: false,
       show_board_composer: false,
       show_card_composer: 0,
       show_list_actions: false,
       show_list_composer: false,
       edit_list_title: 0,
       edit_card_title: 0
     )}
  end

  def update_board_for_subscribers(board_id) do
    Phoenix.PubSub.broadcast_from!(
      Phellow.PubSub,
      self(),
      @topic,
      {__MODULE__, {:update_board, board_id}}
    )

    # Phoenix.PubSub.broadcast(
    #   Phellow.PubSub,
    #   @topic,
    #   {__MODULE__, {:update_board, board_id}}
    # )
  end

  def handle_event("show_boards", %{"should_show" => value}, socket) do
    case value do
      "true" -> {:noreply, assign(socket, show_boards: true)}
      "false" -> {:noreply, assign(socket, show_boards: false)}
    end
  end

  def handle_event("set_current_board", %{"board_id" => id}, socket) do
    board = Content.get_board!(id)

    {:noreply,
     assign(socket,
       current_board: board,
       boards: boards_to_select(board),
       show_boards: false,
       lists: Content.lists_for_board(board.id)
     )}
  end

  def handle_event(
        "show_list_actions",
        %{"should_show" => "true", "left" => x, "top" => y, "list_id" => list_id},
        socket
      ) do
    {:noreply,
     assign(socket,
       show_list_actions: true,
       list_actions_x: x,
       list_actions_y: y,
       list_actions_list_id: list_id
     )}
  end

  def handle_event("show_board_composer", %{"should_show" => value}, socket) do
    case value do
      "true" -> {:noreply, assign(socket, show_board_composer: true)}
      "false" -> {:noreply, assign(socket, show_board_composer: false)}
    end
  end

  def handle_event("add_board", %{"board" => %{"title" => title}}, socket) do
    case Content.create_board(%{"title" => title}) do
      {:ok, board} ->
        {:noreply,
         assign(socket,
           lists: Content.lists_for_board(board.id),
           current_board: board,
           boards: boards_to_select(board),
           show_board_composer: 0
         )}

      {:error, error} ->
        IO.inspect(error.errors)
    end
  end

  def handle_event("show_list_actions", %{"should_show" => "false"}, socket) do
    {:noreply, assign(socket, show_list_actions: false)}
  end

  def handle_event("show_list_composer", %{"should_show" => value}, socket) do
    case value do
      "true" -> {:noreply, assign(socket, show_list_composer: true)}
      "false" -> {:noreply, assign(socket, show_list_composer: false)}
    end
  end

  def handle_event("add_list", %{"list" => %{"title" => title, "board_id" => id}}, socket) do
    Content.create_list(%{"title" => title, "board_id" => id})

    update_board_for_subscribers(socket.assigns.current_board.id)
    {:noreply, assign(socket, lists: Content.lists_for_board(id))}
  end

  def handle_event("reorder_list", %{"list_id" => list_id, "to_position" => to_position}, socket) do
    list = Content.get_list!(list_id)

    Phellow.Repo.transaction(fn ->
      Content.reorder_lists(list.position, to_position)
      Content.update_list(list, %{position: to_position})
    end)

    update_board_for_subscribers(socket.assigns.current_board.id)
    {:noreply, assign(socket, lists: current_lists(socket))}
  end

  def handle_event("archive_list", %{"list_id" => list_id}, socket) do
    list = Content.get_list!(list_id)
    Content.delete_list(list)

    update_board_for_subscribers(socket.assigns.current_board.id)
    {:noreply, assign(socket, lists: current_lists(socket), show_list_actions: false)}
  end

  def handle_event("move_card", params, socket) do
    %{
      "to_list" => to_list,
      "to_position" => to_position,
      "card_id" => card_id
    } = params

    Content.move_card_to_list(card_id, to_list, to_position)

    update_board_for_subscribers(socket.assigns.current_board.id)
    {:noreply, assign(socket, lists: current_lists(socket))}
  end

  def handle_event("add_card", %{"card" => %{"title" => title, "list_id" => list_id}}, socket) do
    ## Make room at beginning of list, kind of a hack
    Content.reorder_list_after_adding_card(%Card{list_id: list_id, position: -1})

    Content.create_card(%{"title" => title, "list_id" => list_id, "position" => 0})

    update_board_for_subscribers(socket.assigns.current_board.id)
    {:noreply, assign(socket, lists: current_lists(socket), show_card_composer: 0)}
  end

  def handle_event("show_card_composer", %{"list_id" => list_id}, socket) do
    {:noreply,
     assign(socket, show_list_actions: false, show_card_composer: String.to_integer(list_id))}
  end

  def handle_event("edit_list_title", %{"list_id" => list_id}, socket) do
    {:noreply, assign(socket, edit_list_title: String.to_integer(list_id))}
  end

  def handle_event("update_list_title", %{"list_id" => list_id, "title" => title}, socket) do
    list = Content.get_list!(list_id)

    if list.title != title do
      Content.update_list(list, %{title: title})
      update_board_for_subscribers(socket.assigns.current_board.id)
      {:noreply, assign(socket, edit_list_title: 0, lists: current_lists(socket))}
    else
      {:noreply, assign(socket, edit_list_title: 0)}
    end
  end

  def handle_event("edit_card_title", %{"card_id" => card_id}, socket) do
    {:noreply, assign(socket, edit_card_title: String.to_integer(card_id))}
  end

  def handle_event("update_card_title", %{"card_id" => card_id, "title" => title}, socket) do
    card = Content.get_card!(card_id)

    if card.title != title do
      Content.update_card(card, %{title: title})
      update_board_for_subscribers(socket.assigns.current_board.id)
      {:noreply, assign(socket, edit_card_title: 0, lists: current_lists(socket))}
    else
      {:noreply, assign(socket, edit_card_title: 0)}
    end
  end

  def handle_event("archive_card", %{"card_id" => id}, socket) do
    card = Content.get_card!(id)

    Phellow.Repo.transaction(fn ->
      Content.delete_card(card)
      Content.reorder_list_after_removing_card(card)
      update_board_for_subscribers(socket.assigns.current_board.id)
    end)

    {:noreply, assign(socket, lists: Content.lists_for_board(1), show_card_composer: 0)}
  end

  # For debugging purposes
  def handle_event(event, params, socket) do
    IO.puts(event)
    IO.inspect(params)

    {:noreply, socket}
  end

  def handle_info({__MODULE__, {:update_board, board_id}}, socket) do
    if socket.assigns.current_board.id == board_id do
      {:noreply, assign(socket, lists: current_lists(socket))}
    else
      {:noreply, socket}
    end
  end

  def handle_info({__MODULE__, data}, socket) do
    IO.puts("Not Handled")
    IO.inspect(data)
    {:noreply, socket}
  end

  def boards_to_select(current_board) do
    Content.list_boards()
    |> Enum.filter(fn board -> board.id != current_board.id end)
  end

  def current_lists(socket) do
    Content.lists_for_board(socket.assigns.current_board.id)
  end
end
