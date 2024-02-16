
--local back_image = love.graphics.newImage("img/pxArt.png")
--[[]
* Black : 0:0:0
* Dark red: 138:76:88
* Pale red: 217:98:117
* Rose:     230:184:193
* Bleue:    69:107:115
* Bleue2:   75:151:166
* Grey:     165:189:194
* White:    255:255:255
]]--
color_darkred = {}
color_darkred.red = 0.72 -- 138
color_darkred.green = 0.13 -- 76
color_darkred.blue = 0.11 -- 88

color_red = {}
color_red.red = 0.85 -- 217
color_red.green = 0.38 -- 98
color_red.blue = 0.45 -- 117

color_roze = {}
color_roze.red = 230
color_roze.green = 184
color_roze.blue = 193

color_blue = {}
color_blue.red = 69
color_blue.green = 107
color_blue.blue = 115


-- 1 menu
-- 2 highscore
-- 3 game
state = 1

score = 0

grid = {}
for i=1, 10 do
    grid[i] = {}
    for j=1, 20 do
        grid[i][j] = 0
    end
end

-- fake it
grid[1][1] = 1
grid[1][2] = 1
grid[2][1] = 1
grid[3][1] = 1
grid[10][1] = 1
grid[10][2] = 1

block = {}
block.shape = "L"
block.x = 5
block.y = 10

function love.load()
    --image = love.graphics.newImage("cake.jpg")
    --love.graphics.setNewFont(12)
    --love.graphics.setColor(0,0,0)
    --love.graphics.setBackgroundColor(255,255,255)

    big_font = love.graphics.newFont("font/kremlin.ttf", 72)
    font = love.graphics.newFont("font/8bitOperatorPlus-Bold.ttf", 18)

    back_image = love.graphics.newImage("img/back.png")


    backhs_image = love.graphics.newImage("img/download.png")

    -- sound for when pieces "block"
    sound_block = love.audio.newSource("sound/block.wav", "static")
    -- sound for when pieces move
    sound_move = love.audio.newSource("sound/move.wav", "static")

    -- main music
    sound_main = love.audio.newSource("sound/folk1.mid", "stream")
    sound_main:play()
end

ts = 0
scale = 0.2
nb_ticks = 0
function love.update(dt)
    if state == 1 then
    end
    if state == 3 then
        sound_main:stop()

        ts = ts + dt
        while ts > scale do 
            nb_ticks = nb_ticks + 1
            ts = ts - scale
        end
        if nb_ticks > 3 then
            nb_ticks = 0
            update_state()
        end
    end
end

function piece_blocked()
    if block.y == 1 then
        return true
    end
    if grid[block.x][block.y-1] == 1 then
        return true
    end
    return false
end

function update_state()
    if piece_blocked() then
        grid[block.x][block.y] = 1
        block.x = 5
        block.y = 20
        sound_block:play()
    else
        block.y = block.y - 1
        sound_move:play()
    end
end

function love.keypressed(key)
    local moved = false
    if key == "up" then
        block.y = block.y + 1
        moved = true
    elseif key == "down" then
        block.y = block.y - 1
    elseif key == "left" then
        block.x = math.max(block.x - 1, 1)
    elseif key == "right" then
        block.x = math.min(block.x + 1, 10)
        moved = true
    end
    if moved then
        sound_move:play()
    end

    -- debug
    if key == "a" then
        state = 1
        sound_main:play()
    elseif key == "z" then
        state = 2
    elseif key == "e" then
        state = 3
    end

    if key == "p" then
        if pause then
            pause = false
        else
            pause = true
        end
    end
    
end

function love.draw()
    
    if state == 1 then
        main_title()
    end
    if state == 2 then
        draw_high_scores()
    end
    if state == 3 then
        draw_game()
    end

end

function main_title()
    -- background
    love.graphics.draw(back_image, 0, 0)

    -- title
    love.graphics.setFont(big_font)
    love.graphics.setColor(color_darkred.red, color_darkred.green, color_darkred.blue)
    love.graphics.print("Tetris", 50+2, 50+2)
    love.graphics.setColor(color_red.red, color_red.green, color_red.blue)
    love.graphics.print("Tetris", 50, 50)
    love.graphics.setColor(255,255,255)

    -- copyright
    love.graphics.setColor(color_darkred.red, color_darkred.green, color_darkred.blue)
    love.graphics.rectangle("fill", 148, 480 - 55, 374, 34)
    love.graphics.setColor(color_roze.red, color_roze.green, color_roze.blue)
    love.graphics.rectangle("fill", 150, 480 - 53, 370, 30)

    love.graphics.setColor(color_red.red,0,0)
    love.graphics.setFont(font)
    love.graphics.print("Copyright 2024 * Damien CAROL", 160,  480 - 50)
    love.graphics.setColor(255,255,255)
end

local backhs_split = 380
local backhs_thickness = 10
function draw_high_scores()
    -- background
    love.graphics.setColor(255,255,255)
    love.graphics.draw(backhs_image, 0, 0)

    -- stats background
    love.graphics.setColor(color_darkred.red, color_darkred.green, color_darkred.blue)
    love.graphics.rectangle("fill", backhs_split, 0, 640 - backhs_split, 480)
    love.graphics.setColor(color_roze.red, color_roze.green, color_roze.blue)
    love.graphics.rectangle("fill", backhs_split + backhs_thickness, backhs_thickness, 640 - backhs_split - backhs_thickness*2, 
    480 - backhs_thickness*2)

    -- stats
    love.graphics.setColor(color_red.red, color_red.green, color_red.blue)
    love.graphics.setFont(font)
    love.graphics.print("123456 DAM", backhs_split + 20,  50*1)
    love.graphics.print(" 23456 GREG", backhs_split + 20,  50*2)
    love.graphics.print(" 13456 ALICE", backhs_split + 20,  50*3)
    love.graphics.setColor(255,255,255)
end

--local backhs_split = 380
--local backhs_thickness = 10
board_width = 300
board_width_blocks = board_width / 10
board_height = 400
board_height_blocks = board_width / 10
function draw_game()
    -- background
    --love.graphics.draw(backhs_image, 0, 0)
    love.graphics.setColor(color_roze.red, color_roze.green, color_roze.blue)
    love.graphics.rectangle("fill", 0, 0, 640, 480)
    
    
    -- board background
    love.graphics.setColor(color_darkred.red, color_darkred.green, color_darkred.blue)
    love.graphics.rectangle("fill", (640-board_width)/2-5, 50-5, board_width+10, board_height+10)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", (640-board_width)/2, 50, board_width, board_height)
    
    -- set blocks
    love.graphics.setColor(color_roze.red, color_roze.green, color_roze.blue)
    for i=1, 10 do
        for j=1, 20 do
            if grid[i][j] == 1 then
                love.graphics.rectangle("fill",
                    (640-board_width)/2 + board_width_blocks*i - board_width_blocks,
                    50 + board_height - board_height_blocks*j, 
                    board_width_blocks, board_height_blocks)
            end
        end
    end

    -- current block
    --love.graphics.setColor(color_blue.red, color_blue.green, color_blue.blue)
    --love.graphics.rectangle("fill",
    --    (640-board_width)/2 + board_width_blocks*block.x - board_width_blocks,
    --    50 + board_height - board_height_blocks*block.y, 
    --    board_width_blocks, board_height_blocks)

    love.graphics.setColor(1,1,1)
end
