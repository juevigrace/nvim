return {
  "OXY2DEV/markview.nvim",
  -- Do not lazy-load markview: it hooks buffer events during startup and
  -- needs to be active before the first markdown buffer is displayed.
  lazy = false,
  opts = {
    preview = {
      icon_provider = "mini",
    },
  },
}
