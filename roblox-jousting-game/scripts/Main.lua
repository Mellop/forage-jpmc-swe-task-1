-- Roblox Jousting Game - Main Entry Point
-- This is the main script that initializes and starts the game

-- Import game modules
local GameManager = require(script.Parent.GameManager)
local PlayerController = require(script.Parent.PlayerController)

-- Game instance variables
local gameManager = nil
local playerController = nil

-- Initialize the game
local function initializeGame()
    print("Initializing Roblox Jousting Game...")
    
    -- Create game manager (server-side logic)
    gameManager = GameManager.new()
    
    -- Create player controller (client-side logic)
    playerController = PlayerController.new()
    
    -- Print welcome message and controls
    print("=================================")
    print("  WELCOME TO ROBLOX JOUSTING!    ")
    print("=================================")
    print("Prepare for medieval combat!")
    print("Mount your steed and ready your lance!")
    print("")
    
    -- Show controls to players
    playerController:printControls()
    
    -- Start the game
    gameManager:startGame()
    
    print("Game initialization complete!")
end

-- Main execution
local function main()
    -- Wait a moment to ensure all systems are ready
    wait(2)
    
    -- Initialize and start the game
    initializeGame()
    
    -- Keep the script running
    while true do
        wait(1)
        -- Game loop continues via event handlers
    end
end

-- Handle any errors during game initialization
local success, errorMessage = pcall(main)

if not success then
    print("Error starting Roblox Jousting Game: " .. tostring(errorMessage))
    print("Please check your script configuration and try again.")
end