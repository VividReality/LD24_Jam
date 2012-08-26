-------------------------------------------------------------------------
-- [gamestate.lua]
-- lib.gamestate
-- A state management library
--
-- to use, Create a gamestate with Gamestate.new()
-- then set the callbacks you need. any callbacks you do not set will
-- simply do nothing.
--
-- When you wish to activate a gamestate, call Gamestate.switch(state), 
-- where 'state' is the gamestate you wish to enter.
--
-- By convention, modules defining new states will place a copy of that 
-- state into gamestate, such that:
-- 	Gamestate.switch(Gamestate.somestate)
-- will be valid, and switch to a state named 'somestate'
--
--
-- Callbacks:
--                enter(self): Invoked whenever we switch to this gamestate
--                leave(self): Invoked whenever we switch away from this state
--           update(self, dt): Invoked on the love.update(dt) event
--                 draw(self): Invoked on the love.draw() event
--           keyreleased(key): Invoked when a keybord key is released
--   keypressed(key, unicode): Invoked when a keybord key is pressed
--   mousereleased(x, y, btn): Invoked when a mouse button is released
--    mousepressed(x, y, btn): Invoked when a mouse button is pressed
-- joystickreleased(joy, btn): Invoked when a joystick button is released
--  joystickpressed(joy, btn): Invoked when a joystick button is pressed
--
-------------------------------------------------------------------------
Gamestate = {}

local function __NULL__() end

-------------------------------------------------------------------------

-- default gamestate produces error on every callback
local function __ERROR__() error("Gamestate not initialized. Use Gamestate.switch()") end
Gamestate.current = {
	enter              = __ERROR__,
	leave              = __NULL__,
	update             = __ERROR__,
	draw               = __ERROR__,
	keyreleased        = __ERROR__,
	keypressed         = __ERROR__,
	mousepressed       = __ERROR__,
	mousereleased      = __ERROR__,
	joystickreleased   = __ERROR__,
	joystickpressed    = __ERROR__,
}

function Gamestate.new()
	return {
		enter             = __NULL__,
		leave             = __NULL__,
		update            = __NULL__,
		draw              = __NULL__,
		keyreleased       = __NULL__,
		keypressed        = __NULL__,
		mousepressed      = __NULL__,
		mousereleased     = __NULL__,
		joystickreleased  = __NULL__,
		joystickpressed   = __NULL__,
	}
end

-------------------------------------------------------------------------

function Gamestate.switch(to, ...)
	if not to then return end
	Gamestate.current:leave()
	local pre = Gamestate.current
	Gamestate.current = to
	Gamestate.current:enter(pre, ...)
end

-------------------------------------------------------------------------

local _update
function Gamestate.update(dt)
	if _update then _update(dt) end
	Gamestate.current:update(dt)
end

-------------------------------------------------------------------------

local _keypressed
function Gamestate.keypressed(key, unicode)
	if _keypressed then _keypressed(key, unicode) end
	Gamestate.current:keypressed(key, unicode)
end

-------------------------------------------------------------------------

local _keyreleased
function Gamestate.keyreleased(key)
	if _keyreleased then _keyreleased(key) end
	Gamestate.current:keyreleased(key)
end

-------------------------------------------------------------------------

local _mousepressed
function Gamestate.mousepressed(x,y,btn)
	if _mousepressed then _mousepressed(x,y,btn) end
	Gamestate.current:mousepressed(x,y,btn)
end

-------------------------------------------------------------------------

local _mousereleased
function Gamestate.mousereleased(x,y,btn)
	if _mousereleased then _mousereleased(x,y,btn) end
	Gamestate.current:mousereleased(x,y,btn)
end

-------------------------------------------------------------------------

local _joystickpressed
function Gamestate.joystickpressed(joystick, button)
	if _joystickpressed then _joystickpressed(joystick, button) end
	Gamestate.current:joystickpressed(joystick, button)
end

-------------------------------------------------------------------------

local _joystickreleased
function Gamestate.joystickreleased(key)
	if _joystickreleased then _joystickreleased(button) end
	Gamestate.current:joystickreleased(button)
end

-------------------------------------------------------------------------

local _draw
function Gamestate.draw()
	if _draw then _draw() end
	Gamestate.current:draw()
end

-------------------------------------------------------------------------

function Gamestate.registerEvents()
	_update            = love.update
	love.update        = Gamestate.update

	_keypressed        = love.keypressed
	love.keypressed    = Gamestate.keypressed
	_keyreleased       = love.keyreleased
	love.keyreleased   = Gamestate.keyreleased

	_mousepressed      = love.mousepressed
	love.mousepressed  = Gamestate.mousepressed
	_mousereleased     = love.mousereleased
	love.mousereleased = Gamestate.mousereleased

	_joystickpressed       = love.joystickpressed
	love.joystickpressed    = Gamestate.joystickpressed
	_joystickreleased       = love.joystickreleased
	love.joystickreleased   = Gamestate.joystickreleased

	_draw              = love.draw
	love.draw          = Gamestate.draw
end

-------------------------------------------------------------------------
return Gamestate

