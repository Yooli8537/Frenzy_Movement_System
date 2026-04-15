-- Made by Yooli8537

-- Gathering required Service
local UserInputService = game:GetService("UserInputService")

local MovementInput = {}

-- Detections for Sprinting, Crouching, Sliding, Jumping and Direction
MovementInput.isSprinting = false
MovementInput.isCrouching = false
MovementInput.isSliding = false
MovementInput.fwd = false
MovementInput.bwd = false
MovementInput.left = false
MovementInput.right = false
MovementInput.isJumping = false
MovementInput.Humanoid = nil

-- Initializing Humanoid to gather Inputs from
function MovementInput:Init(Humanoid)
	self.Humanoid = Humanoid
end

-- Functions from here on out detect different keys and change the Values at the top.
function MovementInput.Sprint(inputObject, processedEvent)
	-- Return if another script has already processed the input
	if processedEvent then return end

	if (inputObject.KeyCode.Name == "LeftShift") then
		MovementInput.isSprinting = true
		MovementInput.isCrouching = false
		return MovementInput.isSprinting, MovementInput.isCrouching
	end
end

function MovementInput.SprintEnd(inputObject, processedEvent)
	if processedEvent then return end

	if (inputObject.KeyCode.Name == "LeftShift") then
		MovementInput.isSprinting = false
		return MovementInput.isSprinting
	end
end

function MovementInput.Crouch(inputObject, processedEvent)
	if processedEvent then return end

	if inputObject.KeyCode.Name == "C" and not MovementInput.isSprinting and not MovementInput.isSliding then
		MovementInput.isCrouching = true
		MovementInput.isSprinting = false
		return MovementInput.isSprinting, MovementInput.isCrouching
	end
end

function MovementInput.CrouchEnd(inputObject, processedEvent)
	if processedEvent then return end

	if inputObject.KeyCode.Name == "C" and not MovementInput.isSprinting and MovementInput.isCrouching then
		MovementInput.isCrouching = false
		return MovementInput.isCrouching
	end
end

function MovementInput.Slide(inputObject, processedEvent)
	if processedEvent then return end

	-- In order to slide, the game checks that you are sprinting.
	if inputObject.KeyCode.Name == "C" and MovementInput.isSprinting then
		MovementInput.isSliding = true
		return MovementInput.isSliding
	end
end

-- To encourage more skilled sliding, I recommend keeping the SlideEnd function call commented out.
-- If you decide to use it, a player can just spam C to stay at the max speed (72) constantly.

function MovementInput.SlideEnd(inputObject, processedEvent)
	if processedEvent then return end

	if inputObject.KeyCode.Name == "C" and MovementInput.isSliding then
		MovementInput.isSliding = false
		return MovementInput.isSliding
	end
end

function MovementInput.Fwd(inputObject, processedEvent)
	if processedEvent then return end

	if inputObject.KeyCode.Name == "W" then
		MovementInput.fwd = true
		return MovementInput.fwd
	end
end

function MovementInput.FwdEnd(inputObject, processedEvent)
	if processedEvent then return end

	if inputObject.KeyCode.Name == "W" then
		MovementInput.fwd = false
		return MovementInput.fwd
	end
end

function MovementInput.Bwd(inputObject, processedEvent)
	if processedEvent then return end

	if inputObject.KeyCode.Name == "S" then
		MovementInput.bwd = true
		return MovementInput.bwd
	end
end

function MovementInput.BwdEnd(inputObject, processedEvent)
	if processedEvent then return end

	if inputObject.KeyCode.Name == "S" then
		MovementInput.bwd = false
		return MovementInput.bwd
	end
end

function MovementInput.Left(inputObject, processedEvent)
	if processedEvent then return end

	if inputObject.KeyCode.Name == "A" then
		MovementInput.left = true
		return MovementInput.left
	end
end

function MovementInput.LeftEnd(inputObject, processedEvent)
	if processedEvent then return end

	if inputObject.KeyCode.Name == "A" then
		MovementInput.left = false
		return MovementInput.left
	end
end

function MovementInput.Right(inputObject, processedEvent)
	if processedEvent then return end

	if inputObject.KeyCode.Name == "D" then
		MovementInput.right = true
		return MovementInput.right
	end
end

function MovementInput.RightEnd(inputObject, processedEvent)
	if processedEvent then return end

	if inputObject.KeyCode.Name == "D" then
		MovementInput.right = false
		return MovementInput.right
	end
end

-- Functions activated by User Input
UserInputService.InputBegan:Connect(MovementInput.Sprint)
UserInputService.InputEnded:Connect(MovementInput.SprintEnd)
UserInputService.InputBegan:Connect(MovementInput.Crouch)
UserInputService.InputEnded:Connect(MovementInput.CrouchEnd)
UserInputService.InputBegan:Connect(MovementInput.Slide)
--UserInputService.InputEnded:Connect(MovementInput.SlideEnd)
UserInputService.InputBegan:Connect(MovementInput.Fwd)
UserInputService.InputEnded:Connect(MovementInput.FwdEnd)
UserInputService.InputBegan:Connect(MovementInput.Bwd)
UserInputService.InputEnded:Connect(MovementInput.BwdEnd)
UserInputService.InputBegan:Connect(MovementInput.Left)
UserInputService.InputEnded:Connect(MovementInput.LeftEnd)
UserInputService.InputBegan:Connect(MovementInput.Right)
UserInputService.InputEnded:Connect(MovementInput.RightEnd)

return MovementInput