defmodule LunchWeb.PageController do
  use LunchWeb, :controller

  def home(conn, _params) do
    render(conn, :home, page_title: "Home")
  end
end
