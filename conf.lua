
function love.conf(t)
    t.identity = "tetris"                -- The name of the save directory (string)

    t.window.title = "Tetris"            -- The window title (string)
    t.window.width = 640
    t.window.height = 480

    t.modules.physics = false            -- Disable the physics module (boolean)
end
