defmodule PhellowWeb.CardComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    editing? = assigns.edit_card_title == assigns.card.id

    ~L"""
    <div class="list-card" data-card-id="<%= @card.id %>" data-list-id="<%= @list_id %>" >
      <div  phx-click="archive_card" phx-value-card_id="<%= @card.id %>">
        <i class="material-icons delete-card">delete</i>
      </div>
      <textarea style="display:<%= if editing?, do: "block", else: "none" %>" autofocus
        name="card-title"  phx-hook="CardTitle" value="<%= @card.title %>" data-card_id="<%= @card.id %>"><%= @card.title %></textarea>
      <div phx-click="edit_card_title" phx-value-card_id="<%= @card.id %>"
       class="list-card-title" style="display: <%= if editing?, do: "none", else: "block" %>" >
        <%= @card.title %>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, socket}
  end

  def update(%{card: card, edit_card_title: edit_card_title, list_id: list_id}, socket) do
    {:ok, assign(socket, card: card, edit_card_title: edit_card_title, list_id: list_id)}
  end
end
