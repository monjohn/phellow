defmodule PhellowWeb.ListLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
        <%= for card <- @cards do %>
          <div class="list-card">
            <div class="list-card-details">
              <%= card.details %>
            </div>
          </div>
        <% end %>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, cards: find_cards())}
  end

  defp find_cards() do
    [%{details: "This is a description of a card"}]
  end
end
