defmodule LunchWeb.DrawingBoardLive do
  @moduledoc false
  use LunchWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Lunch.PubSub, "drawing")

    {:ok, assign(socket, points: [], color: random_color(), page_title: "Drawing board")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>Collaborative drawing board</.header>

      <:breadcrumb>{@page_title}</:breadcrumb>

      <div class="flex gap-2">
        <div id="drawing-board" phx-hook="DrawingBoard" phx-update="ignore" data-color={@color}>
          <canvas width="600" height="400" class="rounded border"></canvas>
        </div>

        <div class="grid">
          <label :for={color <- colors()} class="flex items-center gap-1">
            <input
              type="radio"
              name="color"
              phx-click="change_color"
              phx-value={color}
              value={color}
              checked={color == @color}
            />
            <span>{color}</span>
          </label>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("dragged", %{"from" => _from, "to" => _to, "color" => _color} = point, socket) do
    Phoenix.PubSub.broadcast_from(Lunch.PubSub, self(), "drawing", {:dragged, point})

    {:noreply, socket}
  end

  def handle_event("change_color", %{"value" => color}, socket) do
    {:noreply, push_event(socket, "changeColor", %{color: color})}
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
