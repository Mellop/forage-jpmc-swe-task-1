-- Roblox Jousting Game - Main Game Manager
-- This script manages the overall game state and player interactions

local GameManager = {}
GameManager.__index = GameManager

-- Game configuration
local GAME_CONFIG = {
    MAX_PLAYERS = 8,
    ROUND_TIME = 180, -- 3 minutes
    ARENA_SIZE = 200,
    RESPAWN_TIME = 5
}

-- Game state
local gameState = {
    isActive = false,
    currentRound = 0,
    players = {},
    scores = {}
}

-- Initialize the game
function GameManager.new()
    local self = setmetatable({}, GameManager)
    self:setupArena()
    self:setupEventHandlers()
    return self
end

-- Setup the jousting arena
function GameManager:setupArena()
    print("Setting up jousting arena...")
    
    -- Create arena baseplate
    local arena = Instance.new("Part")
    arena.Name = "JoustingArena"
    arena.Size = Vector3.new(GAME_CONFIG.ARENA_SIZE, 4, GAME_CONFIG.ARENA_SIZE)
    arena.Position = Vector3.new(0, -2, 0)
    arena.Material = Enum.Material.Grass
    arena.BrickColor = BrickColor.new("Bright green")
    arena.Anchored = true
    arena.Parent = workspace
    
    -- Create arena walls
    self:createArenaWalls()
    
    -- Create spawn points
    self:createSpawnPoints()
    
    print("Arena setup complete!")
end

-- Create arena boundary walls
function GameManager:createArenaWalls()
    local wallHeight = 10
    local wallThickness = 2
    
    -- North wall
    local northWall = Instance.new("Part")
    northWall.Size = Vector3.new(GAME_CONFIG.ARENA_SIZE, wallHeight, wallThickness)
    northWall.Position = Vector3.new(0, wallHeight/2, GAME_CONFIG.ARENA_SIZE/2)
    northWall.Material = Enum.Material.Cobblestone
    northWall.BrickColor = BrickColor.new("Medium stone grey")
    northWall.Anchored = true
    northWall.Parent = workspace
    
    -- South wall
    local southWall = northWall:Clone()
    southWall.Position = Vector3.new(0, wallHeight/2, -GAME_CONFIG.ARENA_SIZE/2)
    southWall.Parent = workspace
    
    -- East wall
    local eastWall = Instance.new("Part")
    eastWall.Size = Vector3.new(wallThickness, wallHeight, GAME_CONFIG.ARENA_SIZE)
    eastWall.Position = Vector3.new(GAME_CONFIG.ARENA_SIZE/2, wallHeight/2, 0)
    eastWall.Material = Enum.Material.Cobblestone
    eastWall.BrickColor = BrickColor.new("Medium stone grey")
    eastWall.Anchored = true
    eastWall.Parent = workspace
    
    -- West wall
    local westWall = eastWall:Clone()
    westWall.Position = Vector3.new(-GAME_CONFIG.ARENA_SIZE/2, wallHeight/2, 0)
    westWall.Parent = workspace
end

-- Create spawn points for players
function GameManager:createSpawnPoints()
    local spawnPoints = {}
    local radius = GAME_CONFIG.ARENA_SIZE * 0.3
    
    for i = 1, GAME_CONFIG.MAX_PLAYERS do
        local angle = (i - 1) * (360 / GAME_CONFIG.MAX_PLAYERS)
        local x = math.cos(math.rad(angle)) * radius
        local z = math.sin(math.rad(angle)) * radius
        
        local spawnPoint = Instance.new("SpawnLocation")
        spawnPoint.Position = Vector3.new(x, 4, z)
        spawnPoint.Size = Vector3.new(6, 1, 6)
        spawnPoint.Material = Enum.Material.Neon
        spawnPoint.BrickColor = BrickColor.new("Bright blue")
        spawnPoint.Anchored = true
        spawnPoint.CanCollide = false
        spawnPoint.Parent = workspace
        
        table.insert(spawnPoints, spawnPoint)
    end
    
    self.spawnPoints = spawnPoints
end

-- Setup event handlers
function GameManager:setupEventHandlers()
    -- Handle player joining
    game.Players.PlayerAdded:Connect(function(player)
        self:onPlayerJoined(player)
    end)
    
    -- Handle player leaving
    game.Players.PlayerRemoving:Connect(function(player)
        self:onPlayerLeft(player)
    end)
end

-- Handle player joining the game
function GameManager:onPlayerJoined(player)
    print("Player " .. player.Name .. " joined the jousting game!")
    
    -- Initialize player data
    gameState.players[player.UserId] = {
        player = player,
        score = 0,
        isAlive = true,
        horse = nil,
        lance = nil
    }
    
    gameState.scores[player.UserId] = 0
    
    -- Setup player character when it spawns
    player.CharacterAdded:Connect(function(character)
        self:setupPlayerCharacter(player, character)
    end)
    
    -- If player already has a character, setup immediately
    if player.Character then
        self:setupPlayerCharacter(player, player.Character)
    end
end

-- Handle player leaving the game
function GameManager:onPlayerLeft(player)
    print("Player " .. player.Name .. " left the jousting game!")
    
    -- Clean up player data
    gameState.players[player.UserId] = nil
    gameState.scores[player.UserId] = nil
end

-- Setup player character for jousting
function GameManager:setupPlayerCharacter(player, character)
    wait(1) -- Wait for character to fully load
    
    -- Give player a horse
    self:givePlayerHorse(player, character)
    
    -- Give player a lance
    self:givePlayerLance(player, character)
    
    -- Setup health monitoring
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            self:onPlayerDied(player)
        end)
    end
end

-- Give player a horse (represented as a seat with visual effects)
function GameManager:givePlayerHorse(player, character)
    local horse = Instance.new("Seat")
    horse.Name = "Horse"
    horse.Size = Vector3.new(4, 2, 6)
    horse.Material = Enum.Material.Leather
    horse.BrickColor = BrickColor.new("Brown")
    horse.Anchored = false
    horse.Position = character.HumanoidRootPart.Position + Vector3.new(0, -1, 0)
    
    -- Add some visual flair to make it look more horse-like
    local horseMesh = Instance.new("SpecialMesh")
    horseMesh.MeshType = Enum.MeshType.FileMesh
    horseMesh.MeshId = "rbxasset://fonts/torso.mesh" -- Simple placeholder
    horseMesh.Scale = Vector3.new(2, 1, 3)
    horseMesh.Parent = horse
    
    -- Add horse movement controls
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = horse
    
    horse.Parent = workspace
    
    -- Store reference to horse
    if gameState.players[player.UserId] then
        gameState.players[player.UserId].horse = horse
    end
end

-- Give player a lance weapon
function GameManager:givePlayerLance(player, character)
    local lance = Instance.new("Tool")
    lance.Name = "Jousting Lance"
    lance.RequiresHandle = true
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.5, 0.5, 8)
    handle.Material = Enum.Material.Wood
    handle.BrickColor = BrickColor.new("Brown")
    handle.Parent = lance
    
    -- Add lance tip
    local tip = Instance.new("Part")
    tip.Name = "LanceTip"
    tip.Size = Vector3.new(0.8, 0.8, 1)
    tip.Material = Enum.Material.Metal
    tip.BrickColor = BrickColor.new("Medium stone grey")
    tip.Shape = Enum.PartType.Cylinder
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = tip
    tip.Parent = handle
    weld.Parent = handle
    
    -- Position tip at end of lance
    tip.CFrame = handle.CFrame * CFrame.new(0, 0, -handle.Size.Z/2 - tip.Size.Z/2)
    
    -- Add lance combat functionality
    lance.Activated:Connect(function()
        self:onLanceActivated(player, lance)
    end)
    
    lance.Parent = player.Backpack
    
    -- Store reference to lance
    if gameState.players[player.UserId] then
        gameState.players[player.UserId].lance = lance
    end
end

-- Handle lance being used
function GameManager:onLanceActivated(player, lance)
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Create lance thrust effect
    local thrust = Instance.new("Part")
    thrust.Name = "LanceThrust"
    thrust.Size = Vector3.new(2, 2, 10)
    thrust.Material = Enum.Material.ForceField
    thrust.BrickColor = BrickColor.new("Bright yellow")
    thrust.Anchored = true
    thrust.CanCollide = false
    thrust.Transparency = 0.5
    thrust.Position = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 6
    thrust.CFrame = humanoidRootPart.CFrame
    thrust.Parent = workspace
    
    -- Check for hits
    local function onTouched(hit)
        local hitCharacter = hit.Parent
        local hitHumanoid = hitCharacter:FindFirstChild("Humanoid")
        local hitPlayer = game.Players:GetPlayerFromCharacter(hitCharacter)
        
        if hitPlayer and hitPlayer ~= player and hitHumanoid then
            -- Deal damage and award points
            self:onPlayerHit(player, hitPlayer, 25)
        end
    end
    
    thrust.Touched:Connect(onTouched)
    
    -- Remove thrust effect after short time
    game:GetService("Debris"):AddItem(thrust, 0.5)
    
    print(player.Name .. " used their lance!")
end

-- Handle player being hit by a lance
function GameManager:onPlayerHit(attacker, victim, damage)
    local victimCharacter = victim.Character
    if not victimCharacter then return end
    
    local humanoid = victimCharacter:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Deal damage
    humanoid.Health = humanoid.Health - damage
    
    -- Award points to attacker
    if gameState.scores[attacker.UserId] then
        gameState.scores[attacker.UserId] = gameState.scores[attacker.UserId] + 10
    end
    
    print(attacker.Name .. " hit " .. victim.Name .. " for " .. damage .. " damage!")
    
    -- Check if victim was eliminated
    if humanoid.Health <= 0 then
        self:onPlayerEliminated(attacker, victim)
    end
end

-- Handle player being eliminated
function GameManager:onPlayerEliminated(eliminator, eliminated)
    print(eliminated.Name .. " was eliminated by " .. eliminator.Name .. "!")
    
    -- Award elimination bonus
    if gameState.scores[eliminator.UserId] then
        gameState.scores[eliminator.UserId] = gameState.scores[eliminator.UserId] + 50
    end
    
    -- Check if round should end
    self:checkRoundEnd()
end

-- Handle player death
function GameManager:onPlayerDied(player)
    print(player.Name .. " died!")
    
    if gameState.players[player.UserId] then
        gameState.players[player.UserId].isAlive = false
    end
    
    -- Respawn player after delay
    wait(GAME_CONFIG.RESPAWN_TIME)
    if player.Character then
        player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
        if gameState.players[player.UserId] then
            gameState.players[player.UserId].isAlive = true
        end
    end
end

-- Check if round should end
function GameManager:checkRoundEnd()
    local alivePlayers = 0
    for _, playerData in pairs(gameState.players) do
        if playerData.isAlive then
            alivePlayers = alivePlayers + 1
        end
    end
    
    if alivePlayers <= 1 then
        self:endRound()
    end
end

-- End current round
function GameManager:endRound()
    print("Round ended!")
    
    -- Display scores
    self:displayScores()
    
    -- Reset for next round
    wait(5)
    self:startNewRound()
end

-- Display current scores
function GameManager:displayScores()
    print("=== JOUSTING SCORES ===")
    
    -- Convert scores to sorted list
    local sortedScores = {}
    for userId, score in pairs(gameState.scores) do
        local player = game.Players:GetPlayerByUserId(userId)
        if player then
            table.insert(sortedScores, {player = player, score = score})
        end
    end
    
    -- Sort by score (highest first)
    table.sort(sortedScores, function(a, b) return a.score > b.score end)
    
    -- Display rankings
    for i, entry in ipairs(sortedScores) do
        print(i .. ". " .. entry.player.Name .. ": " .. entry.score .. " points")
    end
    
    print("=====================")
end

-- Start a new round
function GameManager:startNewRound()
    gameState.currentRound = gameState.currentRound + 1
    gameState.isActive = true
    
    print("Starting Round " .. gameState.currentRound .. "!")
    
    -- Reset all players
    for userId, playerData in pairs(gameState.players) do
        playerData.isAlive = true
        if playerData.player.Character then
            local humanoid = playerData.player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end
end

-- Start the game
function GameManager:startGame()
    print("Roblox Jousting Game Started!")
    self:startNewRound()
end

return GameManager