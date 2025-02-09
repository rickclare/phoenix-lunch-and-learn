defmodule LunchWeb.DrawingBoardLive do
  @moduledoc false
  use LunchWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Lunch.PubSub, "drawing")
    {:ok, assign(socket, points: [], color: random_color())}
  end

  def render(assigns) do
    ~H"""
    <h1>Collaborative Drawing Board</h1>

    <div id="drawing-board" phx-hook="DrawingBoard" phx-update="ignore" data-color={@color}>
      <canvas width="600" height="400" class="rounded border"></canvas>
    </div>
    """
  end

  def handle_info({:new_point, point}, socket) do
    {:noreply, push_event(socket, "new_point", point)}
  end

  def handle_event("new_point", point, socket) do
    Phoenix.PubSub.broadcast(Lunch.PubSub, "drawing", {:new_point, point})
    {:noreply, socket}
  end

  defp random_color do
    Enum.random([
      "aqua",
      "blue",
      "fuchsia",
      "green",
      "lime",
      "maroon",
      "olive",
      "purple",
      "red",
      "teal",
      "yellow"
    ])
  end
end
