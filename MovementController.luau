-- Made by Yooli8537

-- This Script wires all the Movement Scripts together per player

-- Gathering required game services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Gathering ModuleScripts
local MovementFolder = ReplicatedStorage:WaitForChild("Movement")
local Config = require(MovementFolder.Config)
local State = require(MovementFolder.State)
local Input = require(MovementFolder.Input)
local MovementLogic = require(MovementFolder.MovementLogic)
local AnimationController = require(game.ReplicatedStorage.Movement.AnimationController)

local player = Players.LocalPlayer

-- Movement initializes once a player is added
local function onCharacterAdded(character)
	if not State.enabled then return end
	local Humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")
	-- Initializing ModuleScripts
	Input:Init(character.Humanoid)
	State:Init(character.Humanoid, character.HumanoidRootPart)
	MovementLogic:Init(character.Humanoid, character.HumanoidRootPart)
	AnimationController:Init(State.Humanoid)

	-- Desired Roblox-side physics (Universal Changes).
	Humanoid.WalkSpeed = 0 -- Setting this to another value will likely break stuns depending on how they are implemented.
	workspace.Gravity = Config.defaultGravity
	State.Humanoid.BreakJointsOnDeath = false -- Looks nicer to me, optional change.
	print("Character Movement Initialization complete")
	print("RigType:", Humanoid.RigType) -- If there are Errors thrown to do with the Neck, check if this outputs R6 or R15. Should be R6.
end

-- Initializes MovementController if player already exists
player.CharacterAppearanceLoaded:Connect(onCharacterAdded)

-- Updating logic every frame
RunService.RenderStepped:Connect(function(dt)
	if State.Humanoid then
		MovementLogic:Update(dt, State, Config)
	end
end)
