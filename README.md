# Frenzy Movement System

This is the Movement System used for my Roblox game Frenzy. Some of the Assets are still glitchy, but overall it works bug-free. Similar to Rivals' Movement System.

## Features

Custom movement options:
- Sprinting
- Crouching
- Sliding
- Acceleration and deceleration
- Movement that doesn't change depending on performance factors such as framerate.

## How it works

This custom Movement Engine primarily works by overriding Roblox' usual horizontal movement and at times the vertical movement. The code sets the walkspeed to 0 which lets the custom movement completely take over. Depending on your movement state (Crouching, Sprinting, Walking), the horizontal speed is calculated with different values. If you're airborne for longer than 0.5s, you will fall slower to enable floatier movement for later features like explosion boosting or jump pads.

## Potentially confusing functions

There are a few features that I feel could be seen as bugs.
- Jumping cancels sliding
- During a slide, you can't change direction
- Default Movement Speed is set to 0
- Gravity is set to 120
- Crouching doesn't have an animation (yet) and changes the player's limbs
- R6 is required, make sure to force R6 characters

## How to run

This project only includes the scripts themselves, not the full workplace. In order to set the movement system up correctly, follow these steps:

- Create a new folder in ReplicatedStorage named "Movement"
- Import all the scripts except for the MovementController into the new folder.
- Import the MovementController into StarterPlayer -> StarterPlayerScripts
- Force R6 Characters by heading to Avarar -> Avatar Settings -> 3 Dots in the top right -> R6 Only
