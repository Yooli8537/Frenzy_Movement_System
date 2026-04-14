-- Made by Yooli8537

-- Gathering required ModuleScript
local State = require(game.ReplicatedStorage.Movement.State)

local MovementAnimationController = {}

MovementAnimationController.Animations = {
	-- Crouch (Not made yet, idk how to make one for R6)
	--CrouchStart = ,
	--CrouchLoop  = ,
	--CrouchEnd = ,

	-- Slide Forwards
	SlideStart = 122210021888337,
	SlideLoop = 113336197685753,
	SlideEnd = 102956838496631,

	-- Slide Backwards
	BackwardSlideStart = 99130318842042,
	BackwardSlideLoop = 94974487988900,
	BackwardSlideEnd = 115711403669314,

	-- Slide Left
	LeftSlideStart = 70611296003686,
	LeftSlideLoop = 128118810290056,
	LeftSlideEnd = 80576915662174,

	-- Slide Right
	RightSlideStart = 131589741207614,
	RightSlideLoop = 127167503323226,
	RightSlideEnd = 87562271428856,
}

MovementAnimationController.Tracks = {}
MovementAnimationController.isSliding = false

function MovementAnimationController:Init(humanoid)
	self.Humanoid = humanoid

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	for name, id in pairs(self.Animations) do
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://"..id

		local track = animator:LoadAnimation(anim)
		track.Priority = Enum.AnimationPriority.Action
		track.Looped = (name == "SlideLoop")

		self.Tracks[name] = track

		track:Play(0)
		track:Stop(0)
	end
end

function MovementAnimationController:SlideStart()
	if self.isSliding then return end
	self.isSliding = true

	self:StopAll()

	local startTrack = self.Tracks.SlideStart
	startTrack.Looped = false

	--print("Playing SlideStart")
	startTrack:Play()
end

function MovementAnimationController:SlideLoop()
	self.isSliding = true

	local loopTrack = self.Tracks.SlideLoop
	loopTrack.Looped = true

	State.slideAnimPhase = "loop"

	--print("Playing SlideLoop")
	if not loopTrack.IsPlaying then
		loopTrack:Play()
	end
end

function MovementAnimationController:SlideEnd(forceStop)
	if not self.isSliding and not forceStop then return end
	self.isSliding = false

	local loopTrack = self.Tracks.SlideLoop
	if loopTrack.IsPlaying then
		loopTrack:Stop(0.1)
	end

	local endTrack = self.Tracks.SlideEnd
	endTrack.Looped = false

	--print("Playing SlideEnd")
	endTrack:Play(0.2)
	self:StopAll()
end

function MovementAnimationController:BackwardSlideStart()
	if self.isSliding then return end
	self.isSliding = true

	self:StopAll()

	local startTrack = self.Tracks.BackwardSlideStart
	startTrack.Looped = false

	--print("Playing BackwardSlideStart")
	startTrack:Play()
end

function MovementAnimationController:BackwardSlideLoop()
	self.isSliding = true

	local loopTrack = self.Tracks.BackwardSlideLoop
	loopTrack.Looped = true

	State.slideAnimPhase = "loop"

	--print("Playing BackwardSlideLoop")
	if not loopTrack.IsPlaying then
		loopTrack:Play()
	end
end

function MovementAnimationController:BackwardSlideEnd(forceStop)
	if not self.isSliding and not forceStop then return end
	self.isSliding = false

	local loopTrack = self.Tracks.BackwardSlideLoop
	if loopTrack.IsPlaying then
		loopTrack:Stop(0.1)
	end

	local endTrack = self.Tracks.BackwardSlideEnd
	endTrack.Looped = false

	--print("Playing BackwardSlideEnd")
	endTrack:Play(0.2)
	self:StopAll()
end

function MovementAnimationController:LeftSlideStart()
	if self.isSliding then return end
	self.isSliding = true

	self:StopAll()

	local startTrack = self.Tracks.LeftSlideStart
	startTrack.Looped = false

	--print("Playing LeftSlideStart")
	startTrack:Play()
end

function MovementAnimationController:LeftSlideLoop()
	self.isSliding = true

	local loopTrack = self.Tracks.LeftSlideLoop
	loopTrack.Looped = true

	State.slideAnimPhase = "loop"

	--print("Playing LeftSlideLoop")
	if not loopTrack.IsPlaying then
		loopTrack:Play()
	end
end

function MovementAnimationController:LeftSlideEnd(forceStop)
	if not self.isSliding and not forceStop then return end
	self.isSliding = false

	local loopTrack = self.Tracks.LeftSlideLoop
	if loopTrack.IsPlaying then
		loopTrack:Stop(0.1)
	end

	local endTrack = self.Tracks.LeftSlideEnd
	endTrack.Looped = false

	--print("Playing LeftSlideEnd")
	endTrack:Play(0.2)
	self:StopAll()
end

function MovementAnimationController:RightSlideStart()
	if self.isSliding then return end
	self.isSliding = true

	self:StopAll()

	local startTrack = self.Tracks.RightSlideStart
	startTrack.Looped = false

	--print("Playing LeftSlideStart")
	startTrack:Play()
end

function MovementAnimationController:RightSlideLoop()
	self.isSliding = true

	local loopTrack = self.Tracks.RightSlideLoop
	loopTrack.Looped = true

	State.slideAnimPhase = "loop"

	--print("Playing RightSlideLoop")
	if not loopTrack.IsPlaying then
		loopTrack:Play()
	end
end

function MovementAnimationController:RightSlideEnd(forceStop)
	if not self.isSliding and not forceStop then return end
	self.isSliding = false

	local loopTrack = self.Tracks.RightSlideLoop
	if loopTrack.IsPlaying then
		loopTrack:Stop(0.1)
	end

	local endTrack = self.Tracks.RightSlideEnd
	endTrack.Looped = false

	--print("Playing RightSlideEnd")
	endTrack:Play(0.2)
	self:StopAll()
end

function MovementAnimationController:StopAll()
	for _, track in pairs(self.Tracks) do
		if track.IsPlaying then
			track:Stop(0.1)
		end
	end
end

return MovementAnimationController
