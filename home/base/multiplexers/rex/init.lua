---@diagnostic disable: undefined-global
rex.bind("alt+h", "pane.focus.left")
rex.bind("alt+j", "pane.focus.down")
rex.bind("alt+k", "pane.focus.up")
rex.bind("alt+l", "pane.focus.right")
rex.bind("alt+n", "pane.split.auto")

rex.bind("ctrl+g>f", "pane.zoom")
rex.bind("ctrl+g>,", "client.tab.move.backward")
rex.bind("ctrl+g>.", "client.tab.move.forward")
rex.bind("ctrl+g>space", "pane.new_floating")
rex.bind("ctrl+g>x", "pane.close")
rex.bind("ctrl+g>ctrl+g", "pane.send_key", { key = "ctrl+g" })
