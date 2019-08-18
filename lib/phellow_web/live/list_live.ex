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

  def mount(%{list_id: id}, socket) do
    {:ok, assign(socket, cards: find_cards(id))}
  end

  defp find_cards(id) do
    case id do
      1 -> [%{details: "This is a description of a card"}]
      2 -> [%{details: "This is a description of another card"}]
      _ -> [%{details: "This is a description of some card"}, %{details: "This is a race card"}]
    end
  end
end
