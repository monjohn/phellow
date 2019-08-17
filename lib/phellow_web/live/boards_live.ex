defmodule PhellowWeb.BoardsLive do
  use Phoenix.LiveView

  def render(assigns) do
    PhellowWeb.BoardView.render("board.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, socket}
    {:ok, assign(socket, lists: find_lists())}
  end

  def find_lists do
    [
      %{title: "List Title", id: 1, cards: [%{details: "This is a description of a card"}]},
      %{title: "Another List", id: 2, cards: [%{details: "This is a description of a card"}]},
      %{title: "A third List", id: 3, cards: [%{details: "This is a description of a card"}]}
    ]
  end
end
