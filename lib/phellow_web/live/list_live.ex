defmodule PhellowWeb.ListLive do
  use Phoenix.LiveView
  alias Phellow.Content

  def render(assigns) do
    ~L"""
      <div class="list-cards" id="<%= @dom_id %>" data-list-id="<%= @list_id %>" >
        <%= for card <- @cards do %>
          <div class="list-card" data-card-id="<%= card.id %>" data-list-id="<%= @list_id %>" >
            <div class="list-card-details">
              <%= card.title %>
            </div>
          </div>
        <% end %>
      </div>
    """
  end

  def mount(%{list_id: list_id}, socket) do
    dom_id = "list" <> Integer.to_string(list_id)

    {:ok,
     assign(socket, cards: Content.cards_for_list(list_id), list_id: list_id, dom_id: dom_id)}
  end

  def handle_info(event, params) do
    IO.puts(event)
    IO.inspect(params)

    {:noreply, nil}
  end
end
