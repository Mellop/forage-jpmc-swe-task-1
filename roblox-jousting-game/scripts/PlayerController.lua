-- Roblox Jousting Game - Player Controller
-- This script handles individual player controls and horse movement

local PlayerController = {}
PlayerController.__index = PlayerController

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Movement configuration
local MOVEMENT_CONFIG = {
    HORSE_SPEED = 30,
    TURN_SPEED = 5,
    LANCE_REACH = 10,
    CHARGE_MULTIPLIER = 1.5
}

-- Create new player controller
function PlayerController.new()
    local self = setmetatable({}, PlayerController)
    self.isCharging = false
    self.currentHorse = nil
    self.currentLance = nil
    self.movement = {
        forward = false,
        backward = false,
        left = false,
        right = false,
        charging = false
    }
    
    self:setupInputHandling()
    self:setupUpdateLoop()
    
    return self
end

-- Setup input handling
function PlayerController:setupInputHandling()
    -- Handle key press events
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            self.movement.forward = true
        elseif input.KeyCode == Enum.KeyCode.S then
            self.movement.backward = true
        elseif input.KeyCode == Enum.KeyCode.A then
            self.movement.left = true
        elseif input.KeyCode == Enum.KeyCode.D then
            self.movement.right = true
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            self.movement.charging = true
            self:startCharge()
        elseif input.KeyCode == Enum.KeyCode.Space then
            self:useLance()
        end
    end)
    
    -- Handle key release events
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            self.movement.forward = false
        elseif input.KeyCode == Enum.KeyCode.S then
            self.movement.backward = false
        elseif input.KeyCode == Enum.KeyCode.A then
            self.movement.left = false
        elseif input.KeyCode == Enum.KeyCode.D then
            self.movement.right = false
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            self.movement.charging = false
            self:endCharge()
        end
    end)
    
    -- Handle mouse clicks for lance attacks
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:useLance()
        end
    end)
end

-- Setup the main update loop
function PlayerController:setupUpdateLoop()
    RunService.Heartbeat:Connect(function()
        self:updateMovement()
        self:updateHorseReference()
    end)
end

-- Update horse reference
function PlayerController:updateHorseReference()
    if player.Character then
        local horse = workspace:FindFirstChild("Horse")
        if horse and horse:IsA("Seat") then
            self.currentHorse = horse
        end
    end
    
    -- Update lance reference
    if player.Character then
        local lance = player.Character:FindFirstChild("Jousting Lance")
        if not lance and player.Backpack then
            lance = player.Backpack:FindFirstChild("Jousting Lance")
        end
        self.currentLance = lance
    end
end

-- Update player movement
function PlayerController:updateMovement()
    if not self.currentHorse or not player.Character then
        return
    end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local bodyVelocity = self.currentHorse:FindFirstChild("BodyVelocity")
    if not bodyVelocity then return end
    
    -- Calculate movement vector
    local moveVector = Vector3.new(0, 0, 0)
    local currentSpeed = MOVEMENT_CONFIG.HORSE_SPEED
    
    -- Apply charging speed boost
    if self.movement.charging then
        currentSpeed = currentSpeed * MOVEMENT_CONFIG.CHARGE_MULTIPLIER
    end
    
    -- Forward/backward movement
    if self.movement.forward then
        moveVector = moveVector + humanoidRootPart.CFrame.LookVector
    end
    if self.movement.backward then
        moveVector = moveVector - humanoidRootPart.CFrame.LookVector
    end
    
    -- Apply movement
    bodyVelocity.Velocity = moveVector * currentSpeed + Vector3.new(0, bodyVelocity.Velocity.Y, 0)
    
    -- Handle turning
    if self.movement.left then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(-MOVEMENT_CONFIG.TURN_SPEED), 0)
    end
    if self.movement.right then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(MOVEMENT_CONFIG.TURN_SPEED), 0)
    end
end

-- Start charging attack
function PlayerController:startCharge()
    if not player.Character then return end
    
    self.isCharging = true
    print(player.Name .. " is charging!")
    
    -- Visual effect for charging
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local chargeEffect = Instance.new("Fire")
        chargeEffect.Name = "ChargeEffect"
        chargeEffect.Size = 5
        chargeEffect.Heat = 10
        chargeEffect.Color = Color3.new(1, 0.5, 0)
        chargeEffect.SecondaryColor = Color3.new(1, 1, 0)
        chargeEffect.Parent = humanoidRootPart
    end
end

-- End charging attack
function PlayerController:endCharge()
    if not player.Character then return end
    
    self.isCharging = false
    print(player.Name .. " stopped charging!")
    
    -- Remove charge effect
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local chargeEffect = humanoidRootPart:FindFirstChild("ChargeEffect")
        if chargeEffect then
            chargeEffect:Destroy()
        end
    end
end

-- Use lance attack
function PlayerController:useLance()
    if not self.currentLance or not player.Character then
        return
    end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    print(player.Name .. " attacks with lance!")
    
    -- Create lance attack effect
    local attackRange = MOVEMENT_CONFIG.LANCE_REACH
    if self.isCharging then
        attackRange = attackRange * 1.5 -- Increased range when charging
    end
    
    -- Raycast for lance hit detection
    local rayOrigin = humanoidRootPart.Position
    local rayDirection = humanoidRootPart.CFrame.LookVector * attackRange
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        local hitCharacter = hitPart.Parent
        local hitHumanoid = hitCharacter:FindFirstChild("Humanoid")
        local hitPlayer = Players:GetPlayerFromCharacter(hitCharacter)
        
        if hitPlayer and hitHumanoid and hitPlayer ~= player then
            -- Calculate damage based on whether we're charging
            local damage = self.isCharging and 35 or 20
            
            -- Deal damage (this would normally be handled server-side)
            hitHumanoid.Health = hitHumanoid.Health - damage
            
            print(player.Name .. " hit " .. hitPlayer.Name .. " for " .. damage .. " damage!")
            
            -- Create hit effect
            self:createHitEffect(raycastResult.Position)
        end
    end
    
    -- Create lance swing effect
    self:createLanceSwingEffect()
end

-- Create visual effect for successful hit
function PlayerController:createHitEffect(position)
    local hitEffect = Instance.new("Explosion")
    hitEffect.Position = position
    hitEffect.BlastRadius = 10
    hitEffect.BlastPressure = 100000
    hitEffect.Parent = workspace
    
    -- Add sparkle effect
    local sparkles = Instance.new("Sparkles")
    local effectPart = Instance.new("Part")
    effectPart.Size = Vector3.new(1, 1, 1)
    effectPart.Position = position
    effectPart.Anchored = true
    effectPart.CanCollide = false
    effectPart.Transparency = 1
    effectPart.Parent = workspace
    
    sparkles.Parent = effectPart
    
    -- Clean up effect after 2 seconds
    game:GetService("Debris"):AddItem(effectPart, 2)
end

-- Create visual effect for lance swing
function PlayerController:createLanceSwingEffect()
    if not player.Character then return end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Create swing trail effect
    local swingEffect = Instance.new("Part")
    swingEffect.Name = "LanceSwing"
    swingEffect.Size = Vector3.new(1, 1, MOVEMENT_CONFIG.LANCE_REACH)
    swingEffect.Material = Enum.Material.ForceField
    swingEffect.BrickColor = BrickColor.new("Bright yellow")
    swingEffect.Anchored = true
    swingEffect.CanCollide = false
    swingEffect.Transparency = 0.7
    swingEffect.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -MOVEMENT_CONFIG.LANCE_REACH/2)
    swingEffect.Parent = workspace
    
    -- Animate the swing
    local tween = game:GetService("TweenService"):Create(
        swingEffect,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Transparency = 1, Size = Vector3.new(3, 3, MOVEMENT_CONFIG.LANCE_REACH)}
    )
    tween:Play()
    
    -- Clean up after animation
    tween.Completed:Connect(function()
        swingEffect:Destroy()
    end)
end

-- Get current movement state (for debugging)
function PlayerController:getMovementState()
    return {
        forward = self.movement.forward,
        backward = self.movement.backward,
        left = self.movement.left,
        right = self.movement.right,
        charging = self.movement.charging,
        isCharging = self.isCharging,
        hasHorse = self.currentHorse ~= nil,
        hasLance = self.currentLance ~= nil
    }
end

-- Print controls to player
function PlayerController:printControls()
    print("=== JOUSTING CONTROLS ===")
    print("W/A/S/D - Move horse")
    print("Left Shift - Charge (hold)")
    print("Space / Left Click - Attack with lance")
    print("========================")
end

return PlayerController