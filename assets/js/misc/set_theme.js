;(() => {
  const setTheme = (theme) => {
    if (theme === "system") {
      localStorage.removeItem("phx:theme")
      document.documentElement.removeAttribute("data-theme")
    } else {
      localStorage.setItem("phx:theme", theme)
      document.documentElement.setAttribute("data-theme", theme)
    }
  }
  setTheme(localStorage.getItem("phx:theme") || "system")
  window.addEventListener(
    "storage",
    (e) => e.key === "phx:theme" && setTheme(e.newValue || "system"),
  )
  window.addEventListener("phx:set-theme", ({ detail: { theme } }) => setTheme(theme))
})()
