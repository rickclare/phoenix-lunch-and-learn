defmodule LunchWeb.CounterLive do
  @moduledoc false
  use LunchWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, 0)}
  end

  def handle_event("increment", _value, socket) do
    {:noreply, update(socket, :count, &(&1 + 1))}
  end

  def handle_event("decrement", _value, socket) do
    {:noreply, update(socket, :count, &(&1 - 1))}
  end

  def render(assigns) do
    ~H"""
    <div class="w-100 grid">
      <button phx-click="increment" class="rounded bg-red-500 p-1 text-white">Up</button>
      <span>Count: {@count}</span>
      <button phx-click="decrement" class="rounded bg-green-500 p-1 text-white">Down</button>
    </div>
    """
  end
end
