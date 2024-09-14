local fg = app.fgColor
local bg = app.bgColor
local rgba = app.pixelColor.rgba

-- default values for dialog options
local options = {
    width = 4,
    height = 4,
    offsetx = 1,
    offsety = 1,
    staggerx = 0,
    staggery = 0,
    fillColor = rgba(fg.red, fg.green, fg.blue, fg.alpha),
    strokeColor = rgba(bg.red, bg.green, bg.blue, bg.alpha)
}

-- validate objects
local image = app.image
if image == nil then
    app.alert("image is nil")
    return
end

local sprite = app.sprite
if sprite == nil then
    app.alert("sprite is nil")
    return
end

local selection = sprite.selection.bounds
if selection.isEmpty then
    app.alert("no pixels are selected")
    return
end

-- draw and fill the bounds of a rectangle
local drawRectangle = function(bounds, fill)
    for it in image:pixels(bounds) do
        it(fill)
    end
end

-- draw an array of rectangles within a selection
local drawRectangleArray = function(option)
    local cols = selection.w / option.width
    local rows = selection.h / option.height
    local origin = selection.origin
    local target = Rectangle(sprite.selection.bounds)
    target.x = origin.x + option.offsetx
    target.y = origin.y + option.offsety
    target.w = option.width
    target.h = option.height

    -- draw rows (vertical)
    for j = 1, math.abs(rows) do
        drawRectangle(target, option.fillColor)
        -- draw columns (horizontal)
        for i = 1, math.abs(cols) do
            drawRectangle(target, option.fillColor)
            target.x = target.x + option.offsetx + target.w
        end
        target.y = target.y + option.offsety + target.h
        target.x = origin.x + option.offsetx
    end
end

local dlg = Dialog("Generate Rectangle Array")
dlg:newrow { always = false }
dlg:number { id = "width", label = "Size:" }
dlg:number { id = "height" }
dlg:number { id = "offsetx", label = "Offset:" }
dlg:number { id = "offsety" }
dlg:number { id = "staggerx", label = "Stagger:" }
dlg:number { id = "staggery" }
dlg:color {
    id = "fillColor",
    label = "Fill",
    color = Color(fg),
    onchange = function()
        local data = dlg.data.fillColor
        options.fillColor = rgba(data.red, data.green, data.blue, data.alpha)
    end
}
dlg:color {
    id = "strokeColor",
    label = "Stroke",
    color = Color(bg),
    onchange = function()
        local data = dlg.data.strokeColor
        options.strokeColor = rgba(data.red, data.green, data.blue, data.alpha)
    end
}
dlg:button {
    id = "ok",
    text = "Ok",
    onclick = function()
        drawRectangleArray(options)
        app.refresh()
        dlg:close()
    end
}
dlg:button {
    id = "cancel",
    text = "Cancel",
    onclick = function()
        dlg:close()
    end
}

dlg:show()
