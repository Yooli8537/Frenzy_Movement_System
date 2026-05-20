-- Made by Yooli8537

local MovementConfig = {}

-- Base Stats (Walking)
MovementConfig.maxSpeed = 20
MovementConfig.acceleration = 75
MovementConfig.friction = 50
MovementConfig.airMultiplier = 50

-- Sprinting
MovementConfig.sprintSpeedMultiplier = 1.5

-- Crouching
MovementConfig.crouchMaxSpeed = MovementConfig.maxSpeed * 0.7
MovementConfig.crouchFriction = MovementConfig.friction * 1.5

-- Sliding
MovementConfig.slideMaxSpeed = MovementConfig.maxSpeed * 4
MovementConfig.slideAcceleration = MovementConfig.acceleration * 2
MovementConfig.slideFriction = MovementConfig.friction * 3
MovementConfig.slideMaxFriction = MovementConfig.slideFriction * 30
MovementConfig.slideBreakFriction = MovementConfig.slideMaxFriction * 0.9 -- Friction required to cancel your slide automatically
MovementConfig.slideResistance = 2.3 -- Speed at which your slide slows

-- Environment Modifiers
MovementConfig.defaultGravity = 120

return MovementConfig