-- Made by Yooli8537

-- Gathering required ModuleScripts
local Config = require(game.ReplicatedStorage.Movement.Config)
local State = require(game.ReplicatedStorage.Movement.State)
local Input = require(game.ReplicatedStorage.Movement.Input)
local AnimationController = require(game.ReplicatedStorage.Movement.AnimationController)

local MovementMovementLogic = {}

-- Initializing logic
function MovementMovementLogic:Init(Humanoid, rootPart)
	-- Gathering Player
	self.Humanoid = Humanoid
	self.rootPart = rootPart

	-- Gathering Config
	self.maxSpeed = Config.maxSpeed
	self.acceleration = Config.acceleration
	self.friction = Config.friction
	self.slideMaxSpeed = Config.slideMaxSpeed
	self.slideAcceleration = Config.slideAcceleration
	self.slideFriction = Config.slideFriction
	print("Successfully Initialized MovementLogic")
end

-- Actual physics engine
function MovementMovementLogic:Update(dt, state)
	State:UpdateGrounded() -- Updating airborne state
	if not state.enabled then return end -- If custom movement isn't enabled, the function is ended

	-- Gathering player bits once again
	local Humanoid = State.Humanoid
	local root = State.rootPart

	-- Safeguards to prevent errors through mindless spamming of inputs
	State.acceleration = State.acceleration or Config.acceleration
	State.friction = State.friction or Config.friction
	State.velocity = State.velocity or Vector3.zero

	-- Detects Jumping
	if Input.Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
		Input.isJumping = true
	else
		Input.isJumping = false
	end

	-- Changes Speed depending on movement state, Jumping gets rid of slides
	if Input.isJumping == true then
		if Input.isSliding == true then
			Input.isSliding = false
			AnimationController:StopAll()
		end
	elseif Input.isSliding == true and State.grounded == true and State.slidingIndex == 0 then
		State.maxSpeed = Config.slideMaxSpeed
		State.acceleration = Config.slideAcceleration
		State.friction = Config.slideFriction
	elseif Input.isCrouching == true then
		State.maxSpeed = Config.crouchMaxSpeed
		State.acceleration = Config.acceleration
		State.friction = Config.crouchFriction
		State:setMovementState(Input.isSliding, Input.isCrouching, Input.isSprinting)
	elseif Input.isSprinting == true then
		State.maxSpeed = Config.maxSpeed * Config.sprintSpeedMultiplier
		State.acceleration = Config.acceleration
		State.friction = Config.friction
		State:setMovementState(Input.isSliding, Input.isCrouching, Input.isSprinting)
	else
		State.maxSpeed = Config.maxSpeed
		State.acceleration = Config.acceleration
		State.friction = Config.friction
		State:setMovementState(Input.isSliding, Input.isCrouching, Input.isSprinting)
	end

	-- Velocity Calculation
	local playerVelocity = State.velocity
	local MoveDirection = State.Humanoid.MoveDirection
	local targetVelocity

	-- Calculating target velocity
	if Input.isSliding == true and State.grounded == true and State.slideDirection then -- SlideDirection must exist to avoid calculations with nil
		-- Sliding on ground
		targetVelocity = State.slideDirection * State.maxSpeed
	elseif Input.isSliding == true and State.grounded == false and State.slideDirection then
		-- Sliding in the air
		targetVelocity = State.slideDirection * State.maxSpeed
	else
		-- For non-sliding states
		targetVelocity = MoveDirection * State.maxSpeed
	end

	-- Calculating player velocity
	local accelFactor = math.clamp(State.acceleration * dt, 0, 0.9) -- Prevents exponential speed overload
	playerVelocity += (targetVelocity - playerVelocity) * accelFactor
	local horizontalVelocity = Vector3.new(playerVelocity.X, 0, playerVelocity.Z)
	local verticalVelocity = State.rootPart.Velocity.Y
	local speed = horizontalVelocity.Magnitude

	-- Proper slide physics
	-- Locking slide direction
	if Input.isSliding == true and State.grounded and not State.slideDirection then
		if MoveDirection.Magnitude > 0 then
			State.slideDirection = MoveDirection.Unit
		else
			State.slideDirection = State.rootPart.CFrame.LookVector
		end
		State.slideTime = 0
	end

	-- Slide friction variables
	local baseFriction = Config.slideFriction
	local maxFriction = Config.slideMaxFriction
	local slideResistance = Config.slideResistance

	-- Calculating friction & breaking point
	if Input.isSliding == true and State.grounded == true then
		State.slideTime += dt
		State.friction = baseFriction + (maxFriction - baseFriction) * (1 - math.exp(-slideResistance * State.slideTime))
		-- Breaking slide once a certain friction (speed) is met
		if State.friction > Config.slideBreakFriction then
			Input.isSliding = false
		end
	elseif  State.airTime > 1.5 then
		Input.isSliding = false
		print("Airtime slide cancel")
	elseif Input.isSliding == true and State.grounded == false then
		State.slideTime = 0
	elseif Input.isSliding == false then
		State.slideDirection = nil
		State.slidingIndex = 0
	end

	-- Friction
	if speed > 0 then
		local currentFriction = State.friction * dt
		local newSpeed = math.max(speed - currentFriction, 0)

		if newSpeed == 0 then
			horizontalVelocity = Vector3.zero
		else
			horizontalVelocity = horizontalVelocity.Unit * newSpeed
		end
	end

	-- Increased Floatiness when airborne for more than 0.5s
	if not State.grounded then
		State.airTime += dt

		if State.airTime > 0.5 and Input.isSliding == false then
			State.maxSpeed *= 5
			State.friction /= State.airMultiplier
			verticalVelocity += Config.airMultiplier * dt
		end
	else
		State.airTime = 0
	end

	-- Preventing velocity from being higher than maximum speed
	if horizontalVelocity.Magnitude > State.maxSpeed then
		horizontalVelocity = horizontalVelocity.Unit * State.maxSpeed
	end

	-- Applying Velocity
	State.velocity = Vector3.new(horizontalVelocity.X, verticalVelocity, horizontalVelocity.Z)
	State.rootPart.Velocity = State.velocity

	-- Animations	
	if Input.isSliding == true then
		State:setMovementState(Input.isSliding, Input.isCrouching, Input.isSprinting)

		-- Checks for Input- & Slidedirection in order to prevent animation switches during slide.
		if (Input.fwd == true and State.currentSlideDirection == nil) or State.currentSlideDirection == "fwd" then

			-- Starting the slide only executes once.
			if State.slidingIndex == 0 then
				State.slidingIndex = 1
				State.currentSlideDirection = "fwd"
				print("Forwards Slide!")
				AnimationController:SlideStart()
				State:setMovementState(Input.isSliding, Input.isCrouching, Input.isSprinting)
			else
				AnimationController:SlideLoop()
			end
		elseif (Input.bwd == true and State.currentSlideDirection == nil) or State.currentSlideDirection == "bwd" then

			if State.slidingIndex == 0 then
				State.slidingIndex = 1
				State.currentSlideDirection = "bwd"
				print("Backwards Slide!")
				AnimationController:BackwardSlideStart()
				State:setMovementState(Input.isSliding, Input.isCrouching, Input.isSprinting)
			else
				AnimationController:BackwardSlideLoop()
			end
		elseif (Input.left == true and State.currentSlideDirection == nil) or State.currentSlideDirection == "left" then

			if State.slidingIndex == 0 then
				State.slidingIndex = 1
				State.currentSlideDirection = "left"
				print("Left Slide!")
				AnimationController:LeftSlideStart()
				State:setMovementState(Input.isSliding, Input.isCrouching, Input.isSprinting)
			else
				AnimationController:LeftSlideLoop()
			end
		elseif (Input.right == true and State.currentSlideDirection == nil) or State.currentSlideDirection == "right" then

			if State.slidingIndex == 0 then
				State.slidingIndex = 1
				State.currentSlideDirection = "right"
				print("Right Slide!")
				AnimationController:RightSlideStart()
				State:setMovementState(Input.isSliding, Input.isCrouching, Input.isSprinting)
			else
				AnimationController:RightSlideLoop()
			end
		else
			if State.slidingIndex == 0 then
				State.slidingIndex = 1
				print("Default Slide!")
				AnimationController:SlideStart()
				State:setMovementState(Input.isSliding, Input.isCrouching, Input.isSprinting)
			else
				AnimationController:SlideLoop()
			end
		end

		-- Once slide has ended, the correct ending plays. Inputs are unreliable since the player could've stopped pressing them
	elseif Input.isSliding == false then

		if State.currentSlideDirection == "fwd" then
			AnimationController:SlideEnd()
		elseif State.currentSlideDirection == "bwd" then
			AnimationController:BackwardSlideEnd()
		elseif State.currentSlideDirection == "left" then
			AnimationController:LeftSlideEnd()
		elseif State.currentSlideDirection == "right" then
			AnimationController:RightSlideEnd()
		else
			AnimationController:SlideEnd()
		end
		State.currentSlideDirection = nil
	end
	print(State.airTime)
end

return MovementMovementLogic