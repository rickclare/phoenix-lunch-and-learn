// Embeds Phosphor Icons (https://phosphoricons.com)
// See `CoreComponents.icon/1` for more information.
const fs = require("fs")
const path = require("path")
const plugin = require("tailwindcss/plugin")

module.exports = plugin(function ({ matchUtilities, theme }) {
  const iconsDir = path.join(__dirname, "../../deps/phosphor_icons/assets")
  const values = {}

  const icons = [
    ["", "/regular"],
    ["-bold", "/bold"],
    ["-duotone", "/duotone"],
    ["-fill", "/fill"],
    ["-light", "/light"],
    ["-thin", "/thin"],
  ]

  icons.forEach(([_suffix, dir]) => {
    fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
      let name = path.basename(file, ".svg")
      values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
    })
  })
  matchUtilities(
    {
      phosphor: ({ name, fullPath }) => {
        let content = fs
          .readFileSync(fullPath)
          .toString()
          .replace(/\r?\n|\r/g, "")

        content = encodeURIComponent(content)

        let size = theme("spacing.6")

        return {
          [`--phosphor-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
          "-webkit-mask": `var(--phosphor-${name})`,
          mask: `var(--phosphor-${name})`,
          "mask-repeat": "no-repeat",
          "background-color": "currentColor",
          "vertical-align": "middle",
          display: "inline-block",
          width: size,
          height: size,
        }
      },
    },
    { values },
  )
})
