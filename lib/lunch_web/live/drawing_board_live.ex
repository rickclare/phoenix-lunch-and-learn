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

  def handle_event("dragged", %{"from" => _from, "to" => _to, "color" => _color} = point, socket) do
    Phoenix.PubSub.broadcast_from(Lunch.PubSub, self(), "drawing", {:dragged, point})

    {:noreply, socket}
  end

  def handle_info({:dragged, point}, socket) do
    {:noreply, push_event(socket, "newLine", point)}
  end

  defp random_color do
    Enum.random(colors())
  end

  defp colors do
    [
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
    ]
  end
end
