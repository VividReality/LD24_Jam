local Gamestate = require "lib.gamestate"
local state = Gamestate.new()
Gamestate.space = state

local Enemy = require("enemy")

local spaceship = love.graphics.newImage("gfx/SpaceShip.png")
local dirt = love.graphics.newImage("gfx/Dirt.png")
local grass = love.graphics.newImage("gfx/Grass.png")
local dirtbottom = love.graphics.newImage("gfx/DirtBottom.png")
local BKG = love.graphics.newImage("gfx/BKG.png")

local SFX_Explosion = love.audio.newSource("sfx/Explosion.wav", "static")

local ship_x
local ship_y
local ship_shield
local shpi_height
local speed = 100

local level = {0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,3,3,3,3,3,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,5,4,3,2,1,1,1,1,1,1,1,1,1,5,5,5,5,5,5,1,1,1,1,1,1,1,1,1,5,6,5,6,5,6,5,6,5,1,1,1,1,1,1,1,1,2,3,4,3,2,3,2,3,4,5,5,5,5,5,4,3,2,1,0}

local level_width = #level
local scroll_speed = 50
local level_x

local Enemies = Enemy.Create(love.graphics.newImage("gfx/Enemy2.png"),300,200)

-- Note: state:enter() is called each time we switch to this state (only from
-- the main menu at the moment) so it is not neccessary to load image files here
-- We should only change instance specific things, such as replacing the
-- ships in the default positions
function state:enter()
	ship_x = 64
	ship_y = 320
	ship_shield = 100 -- and this
	ship_height = 19
	level_x = -640
end

function state:update(dt)

	level_x = level_x + scroll_speed * dt
	
	if level_x > level_width * 32 then

		level_x = -640
	
	end

	if love.keyboard.isDown("right") then
		ship_x = ship_x + speed * dt
	elseif love.keyboard.isDown("left") then
		ship_x = ship_x - speed * dt
	end
	
	if love.keyboard.isDown("down") then
		ship_y =  ship_y + speed * dt
	elseif love.keyboard.isDown("up") then
		ship_y = ship_y - speed * dt
	end
	
	Collision()
end

function Collision() -- this is new

CurrentTileX = round(ship_x / 32 + level_x / 32, 0)

if CurrentTileX > 0 and CurrentTileX < level_width then
		if ship_y < (level[CurrentTileX] + 1) * 32 then
			ship_shield = ship_shield - 1
			ship_y = ship_y + 5
			
			love.audio.play(SFX_Explosion)
		end

		if ship_y + ship_height > (15 - level[CurrentTileX]) * 32 then
			ship_shield = ship_shield + 1
			ship_y = ship_y - 5
			
			love.audio.play(SFX_Explosion)
		end
		
		if ship_y < (level[CurrentTileX + 1] + 1) * 32 then
			ship_shield = ship_shield - 1
			ship_y = ship_y + 5
			
			love.audio.play(SFX_Explosion)
		end

		if ship_y + ship_height > (15 - level[CurrentTileX + 1]) * 32 then
			ship_shield = ship_shield + 1
			ship_y = ship_y - 5
			
			love.audio.play(SFX_Explosion)
		end
	end
end

function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

local function drawlevel()


	for x=1, level_width do		
			for y=1, level[x] do
			
				love.graphics.draw(dirt,(x*32) - level_x ,y*32)
				love.graphics.draw(dirt,(x*32) - level_x ,(15 - y) * 32)
				
				
				
				if y == level[x] then
				love.graphics.draw(dirtbottom,(x*32) - level_x ,y*32)
				love.graphics.draw(grass,(x*32) - level_x ,(15 - y) * 32)
				end
				
			end
	end
end

function state:draw()
	love.graphics.draw(BKG, - level_x % 800, 0)
	love.graphics.draw(BKG, - level_x % 800 - 800, 0)
	love.graphics.draw(spaceship,ship_x,ship_y)
	Enemies:Draw()
	drawlevel()
end