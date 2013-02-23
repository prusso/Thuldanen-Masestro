require "utils.BaseState"
PlayerReadyState = {}

function PlayerReadyState:new()
	local state = BaseState:new("ready")
	
	function state:onEnterState(event)
		print("ready state")
		local player = self.entity
		
		player:showSprite("stand")
		
		Runtime:addEventListener("onMovePlayerRightStarted", self)
		Runtime:addEventListener("onMovePlayerLeftStarted", self)
		
		Runtime:addEventListener("onJumpPlayerRight", self)
		Runtime:addEventListener("onJumpPlayerLeft", self)
		Runtime:addEventListener("onAttackStarted", self)

		Runtime:addEventListener("onPlayerGrappleTreasure", self)
	end
	
	function state:onExitState(event)
		local player = self.entity
		
		Runtime:removeEventListener("onMovePlayerRightStarted", self)
		Runtime:removeEventListener("onMovePlayerLeftStarted", self)
		
		Runtime:removeEventListener("onJumpPlayerRight", self)
		Runtime:removeEventListener("onJumpPlayerLeft", self)
		Runtime:removeEventListener("onAttackStarted", self)

		Runtime:removeEventListener("onPlayerGrappleTreasure", self)
	end
	
	function state:tick(time)
		local player = self.entity
	end
	
	function state:onMovePlayerLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("moveLeft")
	end
	
	function state:onMovePlayerRightStarted(event)
		self.stateMachine:changeStateToAtNextTick("moveRight")
	end
	
	function state:onAttackStarted(event)
		self.stateMachine:changeStateToAtNextTick("attack")
	end
	
	function state:onJumpPlayerLeft(event)
		self.stateMachine:changeStateToAtNextTick("jumpLeft")
	end
	
	function state:onJumpPlayerRight(event)
		self.stateMachine:changeStateToAtNextTick("jumpRight")
	end

	function state:onPlayerGrappleTreasure()
		self.stateMachine:changeStateToAtNextTick("grappleTreasure")
	end
	
	return state
end

return PlayerReadyState