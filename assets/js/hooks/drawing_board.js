export const DrawingBoard = {
  mounted() {
    const canvas = this.el.querySelector("canvas")
    const ctx = canvas.getContext("2d")
    const color = this.el.dataset.color

    let drawing = false
    let lastPoint = null

    canvas.addEventListener("mousedown", (event) => {
      drawing = true
      const rect = canvas.getBoundingClientRect()
      const x = event.clientX - rect.left
      const y = event.clientY - rect.top
      lastPoint = { x, y }
    })

    canvas.addEventListener("mouseup", () => {
      drawing = false
      lastPoint = null
    })

    canvas.addEventListener("mousemove", (event) => {
      if (!drawing) return

      const rect = canvas.getBoundingClientRect()
      const x = event.clientX - rect.left
      const y = event.clientY - rect.top
      const currentPoint = { x, y }

      this.pushEvent("new_point", {
        x,
        y,
        last_x: lastPoint.x,
        last_y: lastPoint.y,
        color: color,
      })
      lastPoint = currentPoint
    })

    this.handleEvent("new_point", ({ x, y, last_x, last_y, color }) => {
      ctx.lineWidth = 2
      ctx.strokeStyle = color

      ctx.beginPath()
      ctx.moveTo(last_x, last_y)
      ctx.lineTo(x, y)
      ctx.stroke()
    })
  },
}
