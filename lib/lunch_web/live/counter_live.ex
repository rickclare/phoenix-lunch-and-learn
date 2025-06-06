defmodule LunchWeb.CounterLive do
  @moduledoc false
  use LunchWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0, page_title: "Counter")}
  end

  def handle_event("increment", _value, socket) do
    {:noreply, update(socket, :count, fn i -> i + 1 end)}
  end

  def handle_event("decrement", _value, socket) do
    if socket.assigns.count < 1, do: raise("Cannot be decrement below 0")

    {:noreply, update(socket, :count, fn i -> i - 1 end)}
  end
end
