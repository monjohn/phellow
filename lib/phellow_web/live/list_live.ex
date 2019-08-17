defmodule PhellowWeb.ListLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
      <div class="list-cards">
        <%= for card <- @cards do %>
          <div class="list-card">
            <div class="list-card-details">
              <%= card.details %>
            </div>
          </div>
        <% end %>

        <div class="open-card-composer">
          <i class="material-icons tiny">add</i>Add a card
        </div>
      </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, cards: find_cards())}
  end

  defp find_cards() do
    [%{details: "This is a description of a card"}]
  end
end
