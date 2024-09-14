local sprite = app.sprite

-- Background Layer
local backgroundColor = Color({ r = 140, g = 140, b = 140, a = 255 })
local backgroundLayer = sprite:newLayer()
backgroundLayer.name = "Background"

app.useTool {
    tool = "paint_bucket",
    color = backgroundColor,
    bgColor = backgroundColor,
    layer = backgroundLayer,
    points = { Point(0, 0) }
}

app.command.BackgroundFromLayer()
app.command.LayerLock()

-- Misc
app.command.ShowGrid()
