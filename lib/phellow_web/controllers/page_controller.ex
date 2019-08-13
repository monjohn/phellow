defmodule PhellowWeb.PageController do
  use PhellowWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
