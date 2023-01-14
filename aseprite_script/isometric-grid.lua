-- [ USER DEFAULTS --]

local defaults = {
    color = Color{r=255, g=255, b=255, a=255}, -- white color
    width = 64,
    maxWidth = app.activeSprite.width,
    maxHeight = app.activeSprite.height,
    opacity = 255
}


local function createLayer(sprite, name, opacity)
    local layer = sprite:newLayer()
    layer.name = name
    layer.isEditable = false
    layer.isContinuous = true
    layer.opacity = opacity
    local cel = sprite:newCel(layer, 1)
    return layer
end

-- [ DRAWING LINES --]
local function drawLines(width, maxWidth, maxHeight, color)
    if (width <= 8) then
        -- quick exit if width is less then 8
        return
    end

    local toLeft = width // 2
    local toRight = width // 2 + 1

    for y = 0, maxHeight, 1 do
        for x = 0, maxWidth, 1 do
            if ( x % width == toLeft)
            then
                -- put pixel on current position
                app.activeImage:putPixel(x, y, color)
                -- put pixel on before position
                app.activeImage:putPixel(x-1, y, color)
            end
            if ( x % width == toRight)
            then
                 -- put pixel on current position
                 app.activeImage:putPixel(x, y, color)
                 -- put pixel on next position
                 app.activeImage:putPixel(x+1, y, color)
            end
        end
        -- change index position for left draw
        -- and reset if less than or equal 0
        toLeft = toLeft - 2
        if (toLeft <= 0)
        then
            toLeft = width
        end
        
        -- change index position for Right draw
        -- and reset if greate than or equal width size
        toRight = toRight + 2
        if (toRight >= width)
        then
            toRight = 0
        end
    end
end


-- [ USER INTERFACE --]

local dlg = Dialog("Isometric Grid")
dlg :separator{text="Size:"}
    :number {id="width", label="Width:", decimals=defaults.size}
    :slider {id="opacity", label="Opacity:", min=0, max=defaults.opacity, value=defaults.opacity}
    :color {id="color", label="Stroke:", color=defaults.color}
    :button {id="ok", text="Draw Guidelines", onclick=function ()
        local data = dlg.data
        app.transaction(function ()
            local sprite = app.activeSprite
            -- creating layer first --
            local layer = createLayer(separator, "Grid", data.opacity)
            drawLines(data.width, sprite.width, sprite.height, data.color)
        end)
        -- refresh screen
        app.command.Undo()
        app.command.Redo()
    end}
    :show{wait=false}
