-- Made by Yooli8537

-- Required Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Required ModuleScripts
local Config = require(game.ReplicatedStorage.Movement.Config)
local Input = require(game.ReplicatedStorage.Movement.Input)

local movementState = {}

-- Disable custom movement when stunned or similar
movementState.enabled = true

-- Player bits
movementState.Humanoid = nil
movementState.rootPart = nil

-- Values for Calculation
movementState.velocity = Vector3.zero
movementState.grounded = false

function movementState:Init(Humanoid, rootPart)
	self.Humanoid = Humanoid
	self.rootPart = rootPart

	-- Applying Config settings
	movementState.maxSpeed = Config.maxSpeed
	movementState.acceleration = Config.acceleration
	movementState.friction = Config.friction
	movementState.airMultiplier = Config.airMultiplier
	movementState.airTime = 0
	movementState.slideDirection = nil
	movementState.slideTime = 0
	movementState.slidingIndex = 0
	movementState.slideAnimPhase = nil
	movementState.slideVelocity = nil
	movementState.currentSlideDirection = nil
	movementState.scheduleCancel = false

	-- Character Joint Parents
	local character = movementState.Humanoid.Parent
	print("RigType:", Humanoid.RigType)
	local torso = character:WaitForChild("Torso")

	-- Character Joints
	self.rootJoint = rootPart:WaitForChild("RootJoint")
	self.neck = torso:WaitForChild("Neck")
	self.rightShoulder = torso:WaitForChild("Right Shoulder")
	self.leftShoulder = torso:WaitForChild("Left Shoulder")
	self.rightLeg = torso:WaitForChild("Right Hip")
	self.leftLeg = torso:WaitForChild("Left Hip")

	-- Applying original Character Joint positions
	self.originalHipHeight = Humanoid.HipHeight
	self.originalNeckC0 = self.neck.C0
	self.originalRootJointC0 = self.rootJoint.C0
	self.originalRightShoulderC0 = self.rightShoulder.C0
	self.originalLeftShoulderC0 = self.leftShoulder.C0
	self.originalRightLegC0 = self.rightLeg.C0
	self.originalLeftLegC0 = self.leftLeg.C0
	print("Successfully initialized states for player: " ..character.Name)
end

function movementState:setMovementState(isSliding, isCrouching, isSprinting)
	if isSliding == true then
		self.Humanoid.HipHeight = self.originalHipHeight - 1.5
	elseif isCrouching == true then
		self.Humanoid.HipHeight = - 1.5
		self.neck.C0 = self.originalNeckC0 * CFrame.new(0, 0, -0.5)
		self.rightLeg.C0 = self.originalRightLegC0 * CFrame.new(0, 1, 0)
		self.leftLeg.C0 = self.originalLeftLegC0 * CFrame.new(0, 1, 0)
	elseif isSprinting == true then
		-- Reset Code here to avoid sliding animation carrying over to sprinting
		-- No custom sprint animation anyways
		self.Humanoid.HipHeight = self.originalHipHeight
		self.neck.C0 = self.originalNeckC0 * CFrame.new(0, 0, 0)
		self.rightLeg.C0 = self.originalRightLegC0 * CFrame.new(0, 0, 0)
		self.leftLeg.C0 = self.originalLeftLegC0 * CFrame.new(0, 0, 0)
		--self.rightShoulder.C0 = self.rightShoulder.C0 * CFrame.Angles(0, 0, math.rad(25))
		--self.leftShoulder.C0 = self.leftShoulder.C0 * CFrame.Angles(0, 0, math.rad(25))
	else
		self.Humanoid.HipHeight = self.originalHipHeight
		self.neck.C0 = self.originalNeckC0 * CFrame.new(0, 0, 0)
		self.rightLeg.C0 = self.originalRightLegC0 * CFrame.new(0, 0, 0)
		self.leftLeg.C0 = self.originalLeftLegC0 * CFrame.new(0, 0, 0)

	end
end

--function movementState:setCrouch(isCrouching, isSprinting)
--	if (isCrouching == true) then
--		self.rightShoulder.C0 = self.rightShoulder.C0 * CFrame.Angles(math.rad(-1), 0, 0)
--		self.leftShoulder.C0 = self.leftShoulder.C0 * CFrame.Angles(math.rad(-1), 0, 0)
--	elseif (isSprinting == true) then
--		self.neck.C0 = self.neck.C0 * CFrame.Angles(0, 0, math.rad(100))
--		self.rightShoulder.C0 = self.rightShoulder.C0 * CFrame.Angles(0, 0, math.rad(-100))
--		self.leftShoulder.C0 = self.leftShoulder.C0 * CFrame.Angles(0, 0, math.rad(100))
--		
--		local character = movementState.Humanoid.Parent
--		local Humanoid = character:WaitForChild("Humanoid")
--		Humanoid.JumpHeight = 10000
--	else
--		self.neck.C0 = self.originalNeckC0
--self.originalHipHeight /= 0.5
--self.originalNeckC0 += 0
--self.originalRootJointC0 += 0
--self.originalRightShoulderC0 += 0
--self.originalLeftShoulderC0 += 0
--	end
--end

function movementState:UpdateGrounded()
	self.grounded = self.Humanoid.FloorMaterial ~= Enum.Material.Air
end

return movementState