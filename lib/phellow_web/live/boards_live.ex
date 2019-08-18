defmodule PhellowWeb.BoardsLive do
  use Phoenix.LiveView

  def render(assigns) do
    PhellowWeb.BoardView.render("board.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, socket}
    {:ok, assign(socket, lists: find_lists())}
  end

  def handle_event("add_list", %{"list" => %{"title" => title}}, socket) do
    new_list = %{id: 4, title: title, cards: []}
    {:noreply, assign(socket, lists: find_lists() ++ [new_list])}
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
