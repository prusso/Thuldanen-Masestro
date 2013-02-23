require "player.Sphere"
require "player.Player"
require "gui.PlayerControls"

LevelView = {}

function LevelView:new()
	local level = display.newGroup()
	level.lastScrollTime = system.getTimer()
	level.sphere = nil
	level.player = nil
	level.scrollScreenTable = nil
	level.playerControls = nil
	level.currentLevel = nil

	function level:init()
		self.sphere = Sphere:new()
		self.player = Player:new()
		self.sphere:disable()
		self.player:disable()

		self.sphere:addEventListener("onSphereTouched", self)
		
		local scrollScreenTable = {}
		self.scrollScreenTable = scrollScreenTable
		function scrollScreenTable:enterFrame()
			level:scrollScreen()
		end

		self.playerControls = PlayerControls:new()
		self:insert(self.playerControls)

		Runtime:addEventListener("onPlayerEnterExitSphere", self)
	end

	function level:loadLevel(levelRequirePath)
		if self.currentLevel then
			self.currentLevel:destroy()
			self.currentLevel = nil
		end
		local level = require(levelRequirePath):new()
		self.currentLevel = level
		level:build()
		self.sphere.x = level.sphereStartX
		self.sphere.y = level.sphereStartY

		if level.sphereStart == true then
			self.sphere:enable()
		else
			self.player:enable()
		end

		self:startScrollScreen()
	end

	function level:scrollScreen()
		local w = mainGroup.width
		local centerX = w / 3
		local centerY = mainGroup.y
		local sphere
		if self.sphere.enabled == true then
			sphere = self.sphere
		else
			sphere = self.player
		end
		local playerX, playerY = sphere:localToContent(0, 0)
		local currentOffsetX = playerX - mainGroup.x
		local currentOffsetY = playerY - mainGroup.y
		local deltaX = playerX - centerX
		--local deltaY = playerY - centerY
		local deltaY = (-sphere.y) - mainGroup.y
		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
		local speed = 0.15
		local passed = system.getTimer() - self.lastScrollTime
		self.lastScrollTime = system.getTimer()
		local moveX = speed * (deltaX / dist) * passed
		local moveY = speed * (deltaY / dist) * passed
		
		moveX = math.round(moveX)
		moveY = math.round(moveY)

		mainGroup.x = mainGroup.x - deltaX
		--mainGroup.y = -(sphere.y - 160)
	end	
	
	function level:startScrollScreen()
		Runtime:addEventListener("enterFrame", self.scrollScreenTable)
	end

	function level:stopScrollScreen()
		Runtime:removeEventListener("enterFrame", self.scrollScreenTable)
	end

	function level:onPlayerEnterExitSphere()
		if self.player.enabled == true then
			local dist = getDistance(self.player, self.sphere)
			if dist <= 143 then
				self.player:disable()
				self.sphere:enable()
				self.playerControls.fsm:changeState("notes")
			end
		end
	end

	function level:onSphereTouched()
		self.sphere:disable()
		self.player:enable()
		self.player.x = self.sphere.x
		self.player.y = self.sphere.y - self.sphere.height / 2
		self.playerControls.fsm:changeState("out")
	end

	level:init()

	return level
end

return LevelView