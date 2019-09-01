defmodule PhellowWeb.ListLive do
  use Phoenix.LiveView
  alias Phellow.Content

  def render(assigns) do
    ~L"""
        <%= for card <- @cards do %>
          <div class="list-card">
            <div class="list-card-details">
              <%= card.title %>
            </div>
          </div>
        <% end %>
    """
  end

  def mount(%{list_id: id}, socket) do
    {:ok, assign(socket, cards: Content.cards_for_list(id))}
  end
end
