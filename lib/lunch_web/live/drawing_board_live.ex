defmodule LunchWeb.DrawingBoardLive do
  @moduledoc false
  use LunchWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Lunch.PubSub, "drawing")

    {:ok, assign(socket, points: [], color: nil, page_title: "Drawing board")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>Collaborative drawing board</.header>

      <:breadcrumb>{@page_title}</:breadcrumb>

      <div class="flex gap-2">
        <.drawing_board />

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

  ###### Function Components ########
  defp drawing_board(assigns) do
    ~H"""
    <div
      id="drawing-board"
      phx-hook=".DrawingBoard"
      phx-update="ignore"
      data-initial-color={random_color()}
    >
      <canvas width="600" height="400" class="rounded border"></canvas>
    </div>

    <% # See https://hexdocs.pm/phoenix_live_view/js-interop.html#colocated-hooks-colocated-javascript %>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".DrawingBoard">
      export default {
        canvas: null,
        ctx: null,
        color: null,
        drawing: false,
        lastPoint: null,

        mounted() {
          this.canvas = this.el.querySelector("canvas");
          this.ctx = this.canvas.getContext("2d");
          this.ctx.lineWidth = 2;
          this.color = this.el.dataset.initialColor;

          this.addListeners();
          this.addHandlers();
        },

        addListeners() {
          this.canvas.addEventListener("mousedown", (event) => {
            this.drawing = true;
            this.lastPoint = this.currentPosition(event);
          });

          this.canvas.addEventListener("mouseup", () => {
            this.drawing = false;
            this.lastPoint = null;
          });

          this.canvas.addEventListener("mousemove", (event) => {
            if (!this.drawing) return;

            const currentPoint = this.currentPosition(event);

            this.drawLine(this.lastPoint, currentPoint, this.color);
            this.pushEvent("dragged", { from: this.lastPoint, to: currentPoint, color: this.color });

            this.lastPoint = currentPoint;
          });
        },

        addHandlers() {
          this.handleEvent("newLine", ({ from, to, color }) => {
            this.drawLine(from, to, color);
          });

          this.handleEvent("changeColor", ({ color }) => {
            this.color = color;
          });
        },

        drawLine(from, to, color) {
          this.ctx.strokeStyle = color;
          this.ctx.beginPath();
          this.ctx.moveTo(from.x, from.y);
          this.ctx.lineTo(to.x, to.y);
          this.ctx.stroke();
        },

        currentPosition(event) {
          const rect = this.canvas.getBoundingClientRect();
          const x = event.clientX - rect.left;
          const y = event.clientY - rect.top;

          return { x, y };
        },
      };
    </script>
    """
  end
end
