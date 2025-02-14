export const DrawingBoard = {
  canvas: null,
  ctx: null,
  color: null,
  drawing: false,
  lastPoint: null,
  mounted() {
    this.canvas = this.el.querySelector("canvas")
    this.ctx = this.canvas.getContext("2d")
    this.ctx.lineWidth = 2
    this.color = this.el.dataset.color

    this.addListeners()
    this.addHandlers()
  },
  addListeners() {
    this.canvas.addEventListener("mousedown", (event) => {
      this.drawing = true
      this.lastPoint = this.currentPosition(event)
    })

    this.canvas.addEventListener("mouseup", () => {
      this.drawing = false
      this.lastPoint = null
    })

    this.canvas.addEventListener("mousemove", (event) => {
      if (!this.drawing) return

      const currentPoint = this.currentPosition(event)

      this.drawLine(this.lastPoint, currentPoint, this.color)
      this.pushEvent("dragged", { from: this.lastPoint, to: currentPoint, color: this.color })

      this.lastPoint = currentPoint
    })
  },
  addHandlers() {
    this.handleEvent("newLine", ({ from, to, color }) => {
      this.drawLine(from, to, color)
    })

    this.handleEvent("changeColor", ({ color }) => {
      this.color = color
    })
  },
  drawLine(from, to, color) {
    this.ctx.strokeStyle = color
    this.ctx.beginPath()
    this.ctx.moveTo(from.x, from.y)
    this.ctx.lineTo(to.x, to.y)
    this.ctx.stroke()
  },
  currentPosition(event) {
    const rect = this.canvas.getBoundingClientRect()
    const x = event.clientX - rect.left
    const y = event.clientY - rect.top

    return { x, y }
  },
}
