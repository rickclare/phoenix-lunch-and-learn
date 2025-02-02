defmodule LunchWeb.PageController do
  use LunchWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
