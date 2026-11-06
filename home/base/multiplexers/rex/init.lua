---@diagnostic disable: undefined-global
rex.bind("alt+h", "pane.focus.left")
rex.bind("alt+j", "pane.focus.down")
rex.bind("alt+k", "pane.focus.up")
rex.bind("alt+l", "pane.focus.right")
rex.bind("alt+n", "pane.split.auto")

rex.bind("ctrl+g>f", "pane.zoom")
rex.bind("ctrl+g>x", "pane.close")
rex.bind("ctrl+g>ctrl+g", "pane.send_key", { key = "ctrl+g" })
rex.bind("ctrl+g>space", "pane.new_floating")

-- Move between tabs
rex.bind("alt+cmd+left", "client.tab.previous")
rex.bind("alt+cmd+up", "client.tab.previous")
rex.bind("alt+cmd+right", "client.tab.next")
rex.bind("alt+cmd+down", "client.tab.next")
rex.bind("ctrl+g>,", "client.tab.move.backward")
rex.bind("ctrl+g>.", "client.tab.move.forward")

-- Move panes mode
rex.mode("move", { exclusive = false })
rex.bind("ctrl+g>m", "client.mode.enter", { name = "move" })
rex.bind("move/h", "pane.move.left")
rex.bind("move/j", "pane.move.down")
rex.bind("move/k", "pane.move.up")
rex.bind("move/l", "pane.move.right")

-- Resize panes mode
rex.mode("resize", { exclusive = false })
rex.bind("ctrl+g>r", "client.mode.enter", { name = "resize" })
rex.bind("resize/h", "pane.resize", { direction = "left" })
rex.bind("resize/j", "pane.resize", { direction = "down" })
rex.bind("resize/k", "pane.resize", { direction = "up" })
rex.bind("resize/l", "pane.resize", { direction = "right" })
rex.bind("resize/=", "pane.balance")
