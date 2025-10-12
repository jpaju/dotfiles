-- Register plugins
require("git"):setup()
require("starship"):setup()

-- FIXME These functions seem not to have any effect currently
-- Customize status bar to display file owner and group
function Status:owner()
  local h = cx.active.current.hovered
  if h == nil or ya.target_family() ~= "unix" then
    return ui.Line {}
  end

  return ui.Line {
    ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
    ui.Span(":"),
    ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
    ui.Span(" "),
  }
end

-- Override status bar render to include owner information
function Status:render(area)
  self.area = area

  local left = ui.Line { self:mode(), self:size(), self:name() }
  local right = ui.Line { self:owner(), self:permissions(), self:percentage(), self:position() }
  return {
    ui.Paragraph(area, { left }),
    ui.Paragraph(area, { right }):align(ui.Paragraph.RIGHT),
    table.unpack(Progress:render(area, right:width())),
  }
end
