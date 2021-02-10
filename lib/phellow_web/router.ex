defmodule PhellowWeb.Router do
  alias PhellowWeb.BoardController
  alias PhellowWeb.ListController

  use PhellowWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :put_root_layout, {PhellowWeb.LayoutView, :app}
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", PhellowWeb do
    pipe_through :browser

    live "/", BoardsLive
    get "/pages", PageController, :index
  end

  scope "/admin" do
    pipe_through :browser

    resources "/boards", BoardController
    resources "/lists", ListController
  end
end
