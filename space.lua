local Gamestate = require "lib.gamestate"
local state = Gamestate.new()
Gamestate.space = state

local Ship = require "ship"

local spaceship = love.graphics.newImage("gfx/SpaceShip.png")
local Enemy2 = love.graphics.newImage("gfx/Enemy2.png")
local dirt = love.graphics.newImage("gfx/Dirt.png")
local grass = love.graphics.newImage("gfx/Grass.png")
local dirtbottom = love.graphics.newImage("gfx/DirtBottom.png")
local BKG = love.graphics.newImage("gfx/BKG.png")

local player_ship = Ship.new {
	texture = spaceship;
	height = 19;
	npc = false;
}

state.enemies = {}

state.level = {
	data = {0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,3,3,3,3,3,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,5,4,3,2,1,1,1,1,1,1,1,1,1,5,5,5,5,5,5,1,1,1,1,1,1,1,1,1,5,6,5,6,5,6,5,6,5,1,1,1,1,1,1,1,1,2,3,4,3,2,3,2,3,4,5,5,5,5,5,4,3,2,1,0};
	x = -640;
	scroll_speed = 50;
}
state.level.width = #state.level.data;


-- Note: state:enter() is called each time we switch to this state (only from
-- the main menu at the moment) so it is not neccessary to load image files here
-- We should only change instance specific things, such as replacing the
-- ships in the default positions
function state:enter()
	-- Reset some player_ship defaults
	player_ship.posx = 64
	player_ship.posy = 320
	player_ship.shield = 100 -- and this

	self.level.x = -640

	local enemies = self.enemies

	for i = 1, 3 do
		enemies[i] = Ship.new {
			posx = math.random(0, 800);
			posy = math.random(0, 600);
			texture = Enemy2;
			height = 32;
		}
	end
end

function state:update(dt)
	local level = state.level

	level.x = level.x + level.scroll_speed * dt

	-- Loop level
	if level.x > level.width * 32 then
		level.x = -640
	end

	player_ship:update(dt, level)

	for _, ship in next, self.enemies do
		ship:update(dt, level)
	end
end

function state:keypressed(key)
	player_ship:keypressed(key)
end

function state:keyreleased(key)
	player_ship:keyreleased(key)
end

function state:draw()
	local level = self.level

	love.graphics.draw(BKG, - level.x % 800, 0)
	love.graphics.draw(BKG, - level.x % 800 - 800, 0)

	self:drawlevel()

	player_ship:draw()

	for _, ship in next, self.enemies do
		ship:draw()
	end
end

function state:drawlevel()
	local level = self.level

	for x=1, level.width do
		for y=1, level.data[x] do
			love.graphics.draw(dirt,(x*32) - level.x ,y*32)
			love.graphics.draw(dirt,(x*32) - level.x ,(15 - y) * 32)

			if y == level.data[x] then
				love.graphics.draw(dirtbottom,(x*32) - level.x ,y*32)
				love.graphics.draw(grass,(x*32) - level.x ,(15 - y) * 32)
			end
		end
	end
end