defmodule LunchWeb.ImageLive do
  @moduledoc false
  use LunchWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <form phx-change="update">
        <input type="range" min="10" max="600" name="width" value={@width} />
        {@width}px
      </form>

      <img phx-click="max" src={~p"/images/logo.svg"} width={@width} />
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, width: 100)}
  end

  def handle_event("update", %{"width" => width}, socket) do
    {:noreply, assign(socket, width: String.to_integer(width))}
  end

  def handle_event("max", _params, socket) do
    {:noreply, assign(socket, width: 600)}
  end
end
