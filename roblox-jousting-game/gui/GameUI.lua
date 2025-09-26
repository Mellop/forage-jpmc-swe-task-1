-- Roblox Jousting Game - User Interface
-- This script creates and manages the game's user interface

local GameUI = {}
GameUI.__index = GameUI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create new GameUI instance
function GameUI.new()
    local self = setmetatable({}, GameUI)
    self.screenGui = nil
    self.scoreFrame = nil
    self.healthBar = nil
    self.crosshair = nil
    self.minimap = nil
    
    self:createMainUI()
    self:createHUD()
    self:createScoreboard()
    
    return self
end

-- Create the main UI container
function GameUI:createMainUI()
    -- Create main ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "JoustingGameUI"
    self.screenGui.ResetOnSpawn = false
    self.screenGui.Parent = playerGui
    
    -- Create title frame
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Size = UDim2.new(0, 400, 0, 100)
    titleFrame.Position = UDim2.new(0.5, -200, 0, 20)
    titleFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    titleFrame.BackgroundTransparency = 0.3
    titleFrame.BorderSizePixel = 2
    titleFrame.BorderColor3 = Color3.new(0.8, 0.6, 0)
    titleFrame.Parent = self.screenGui
    
    -- Add corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = titleFrame
    
    -- Create title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "⚔️ ROBLOX JOUSTING ⚔️"
    titleLabel.TextColor3 = Color3.new(1, 0.8, 0)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.FantasyItalic
    titleLabel.TextStrokeTransparency = 0
    titleLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    titleLabel.Parent = titleFrame
    
    -- Animate title entrance
    titleFrame.Position = UDim2.new(0.5, -200, -1, 0)
    local titleTween = TweenService:Create(
        titleFrame,
        TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -200, 0, 20)}
    )
    titleTween:Play()
end

-- Create HUD elements
function GameUI:createHUD()
    -- Health bar
    self:createHealthBar()
    
    -- Crosshair
    self:createCrosshair()
    
    -- Controls reminder
    self:createControlsReminder()
    
    -- Charge meter
    self:createChargeMeter()
end

-- Create health bar
function GameUI:createHealthBar()
    local healthFrame = Instance.new("Frame")
    healthFrame.Name = "HealthFrame"
    healthFrame.Size = UDim2.new(0, 250, 0, 40)
    healthFrame.Position = UDim2.new(0, 20, 1, -80)
    healthFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    healthFrame.BorderSizePixel = 2
    healthFrame.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    healthFrame.Parent = self.screenGui
    
    -- Health bar background
    local healthBG = Instance.new("Frame")
    healthBG.Name = "HealthBackground"
    healthBG.Size = UDim2.new(1, -6, 1, -6)
    healthBG.Position = UDim2.new(0, 3, 0, 3)
    healthBG.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    healthBG.BorderSizePixel = 0
    healthBG.Parent = healthFrame
    
    -- Health bar fill
    self.healthBar = Instance.new("Frame")
    self.healthBar.Name = "HealthBar"
    self.healthBar.Size = UDim2.new(1, 0, 1, 0)
    self.healthBar.Position = UDim2.new(0, 0, 0, 0)
    self.healthBar.BackgroundColor3 = Color3.new(0, 0.8, 0)
    self.healthBar.BorderSizePixel = 0
    self.healthBar.Parent = healthBG
    
    -- Health text
    local healthText = Instance.new("TextLabel")
    healthText.Name = "HealthText"
    healthText.Size = UDim2.new(1, 0, 1, 0)
    healthText.Position = UDim2.new(0, 0, 0, 0)
    healthText.BackgroundTransparency = 1
    healthText.Text = "❤️ HEALTH: 100/100"
    healthText.TextColor3 = Color3.new(1, 1, 1)
    healthText.TextScaled = true
    healthText.Font = Enum.Font.GothamBold
    healthText.TextStrokeTransparency = 0
    healthText.TextStrokeColor3 = Color3.new(0, 0, 0)
    healthText.Parent = healthFrame
    
    -- Store reference
    self.healthText = healthText
end

-- Create crosshair
function GameUI:createCrosshair()
    self.crosshair = Instance.new("Frame")
    self.crosshair.Name = "Crosshair"
    self.crosshair.Size = UDim2.new(0, 40, 0, 40)
    self.crosshair.Position = UDim2.new(0.5, -20, 0.5, -20)
    self.crosshair.BackgroundTransparency = 1
    self.crosshair.Parent = self.screenGui
    
    -- Horizontal line
    local hLine = Instance.new("Frame")
    hLine.Size = UDim2.new(1, 0, 0, 2)
    hLine.Position = UDim2.new(0, 0, 0.5, -1)
    hLine.BackgroundColor3 = Color3.new(1, 1, 1)
    hLine.BorderSizePixel = 0
    hLine.Parent = self.crosshair
    
    -- Vertical line
    local vLine = Instance.new("Frame")
    vLine.Size = UDim2.new(0, 2, 1, 0)
    vLine.Position = UDim2.new(0.5, -1, 0, 0)
    vLine.BackgroundColor3 = Color3.new(1, 1, 1)
    vLine.BorderSizePixel = 0
    vLine.Parent = self.crosshair
    
    -- Center dot
    local centerDot = Instance.new("Frame")
    centerDot.Size = UDim2.new(0, 6, 0, 6)
    centerDot.Position = UDim2.new(0.5, -3, 0.5, -3)
    centerDot.BackgroundColor3 = Color3.new(1, 0, 0)
    centerDot.BorderSizePixel = 0
    centerDot.Parent = self.crosshair
    
    -- Make center dot round
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = centerDot
end

-- Create controls reminder
function GameUI:createControlsReminder()
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "ControlsFrame"
    controlsFrame.Size = UDim2.new(0, 200, 0, 120)
    controlsFrame.Position = UDim2.new(1, -220, 1, -140)
    controlsFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    controlsFrame.BackgroundTransparency = 0.5
    controlsFrame.BorderSizePixel = 1
    controlsFrame.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
    controlsFrame.Parent = self.screenGui
    
    -- Add corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = controlsFrame
    
    -- Controls text
    local controlsText = Instance.new("TextLabel")
    controlsText.Name = "ControlsText"
    controlsText.Size = UDim2.new(1, -10, 1, -10)
    controlsText.Position = UDim2.new(0, 5, 0, 5)
    controlsText.BackgroundTransparency = 1
    controlsText.Text = "🎮 CONTROLS:\nWASD - Move\n⇧ Shift - Charge\n🖱️ Click - Attack\nSpace - Lance"
    controlsText.TextColor3 = Color3.new(1, 1, 1)
    controlsText.TextSize = 12
    controlsText.Font = Enum.Font.Gotham
    controlsText.TextXAlignment = Enum.TextXAlignment.Left
    controlsText.TextYAlignment = Enum.TextYAlignment.Top
    controlsText.TextStrokeTransparency = 0
    controlsText.TextStrokeColor3 = Color3.new(0, 0, 0)
    controlsText.Parent = controlsFrame
end

-- Create charge meter
function GameUI:createChargeMeter()
    local chargeFrame = Instance.new("Frame")
    chargeFrame.Name = "ChargeFrame"
    chargeFrame.Size = UDim2.new(0, 250, 0, 30)
    chargeFrame.Position = UDim2.new(0, 20, 1, -120)
    chargeFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    chargeFrame.BorderSizePixel = 2
    chargeFrame.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    chargeFrame.Parent = self.screenGui
    
    -- Charge bar background
    local chargeBG = Instance.new("Frame")
    chargeBG.Name = "ChargeBackground"
    chargeBG.Size = UDim2.new(1, -6, 1, -6)
    chargeBG.Position = UDim2.new(0, 3, 0, 3)
    chargeBG.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    chargeBG.BorderSizePixel = 0
    chargeBG.Parent = chargeFrame
    
    -- Charge bar fill
    self.chargeMeter = Instance.new("Frame")
    self.chargeMeter.Name = "ChargeMeter"
    self.chargeMeter.Size = UDim2.new(0, 0, 1, 0)
    self.chargeMeter.Position = UDim2.new(0, 0, 0, 0)
    self.chargeMeter.BackgroundColor3 = Color3.new(1, 0.5, 0)
    self.chargeMeter.BorderSizePixel = 0
    self.chargeMeter.Parent = chargeBG
    
    -- Charge text
    local chargeText = Instance.new("TextLabel")
    chargeText.Name = "ChargeText"
    chargeText.Size = UDim2.new(1, 0, 1, 0)
    chargeText.Position = UDim2.new(0, 0, 0, 0)
    chargeText.BackgroundTransparency = 1
    chargeText.Text = "⚡ CHARGE READY"
    chargeText.TextColor3 = Color3.new(1, 1, 1)
    chargeText.TextScaled = true
    chargeText.Font = Enum.Font.GothamBold
    chargeText.TextStrokeTransparency = 0
    chargeText.TextStrokeColor3 = Color3.new(0, 0, 0)
    chargeText.Parent = chargeFrame
    
    -- Store reference
    self.chargeText = chargeText
end

-- Create scoreboard
function GameUI:createScoreboard()
    self.scoreFrame = Instance.new("Frame")
    self.scoreFrame.Name = "ScoreFrame"
    self.scoreFrame.Size = UDim2.new(0, 300, 0, 200)
    self.scoreFrame.Position = UDim2.new(1, -320, 0, 140)
    self.scoreFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    self.scoreFrame.BackgroundTransparency = 0.3
    self.scoreFrame.BorderSizePixel = 2
    self.scoreFrame.BorderColor3 = Color3.new(0.8, 0.6, 0)
    self.scoreFrame.Parent = self.screenGui
    
    -- Add corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = self.scoreFrame
    
    -- Scoreboard title
    local scoreTitle = Instance.new("TextLabel")
    scoreTitle.Name = "ScoreTitle"
    scoreTitle.Size = UDim2.new(1, 0, 0, 30)
    scoreTitle.Position = UDim2.new(0, 0, 0, 0)
    scoreTitle.BackgroundTransparency = 1
    scoreTitle.Text = "🏆 LEADERBOARD"
    scoreTitle.TextColor3 = Color3.new(1, 0.8, 0)
    scoreTitle.TextSize = 18
    scoreTitle.Font = Enum.Font.FantasyItalic
    scoreTitle.TextStrokeTransparency = 0
    scoreTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
    scoreTitle.Parent = self.scoreFrame
    
    -- Scores list
    local scoresList = Instance.new("ScrollingFrame")
    scoresList.Name = "ScoresList"
    scoresList.Size = UDim2.new(1, -10, 1, -40)
    scoresList.Position = UDim2.new(0, 5, 0, 35)
    scoresList.BackgroundTransparency = 1
    scoresList.ScrollBarThickness = 5
    scoresList.Parent = self.scoreFrame
    
    -- Store reference
    self.scoresList = scoresList
end

-- Update health display
function GameUI:updateHealth(currentHealth, maxHealth)
    if not self.healthBar or not self.healthText then return end
    
    local healthPercent = currentHealth / maxHealth
    self.healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
    self.healthText.Text = "❤️ HEALTH: " .. math.floor(currentHealth) .. "/" .. maxHealth
    
    -- Change color based on health
    if healthPercent > 0.6 then
        self.healthBar.BackgroundColor3 = Color3.new(0, 0.8, 0) -- Green
    elseif healthPercent > 0.3 then
        self.healthBar.BackgroundColor3 = Color3.new(1, 0.8, 0) -- Orange
    else
        self.healthBar.BackgroundColor3 = Color3.new(0.8, 0, 0) -- Red
    end
end

-- Update charge meter
function GameUI:updateCharge(isCharging, chargeLevel)
    if not self.chargeMeter or not self.chargeText then return end
    
    if isCharging then
        self.chargeMeter.Size = UDim2.new(chargeLevel or 1, 0, 1, 0)
        self.chargeText.Text = "⚡ CHARGING!"
        self.chargeMeter.BackgroundColor3 = Color3.new(1, 0.5, 0) -- Orange
    else
        self.chargeMeter.Size = UDim2.new(1, 0, 1, 0)
        self.chargeText.Text = "⚡ CHARGE READY"
        self.chargeMeter.BackgroundColor3 = Color3.new(0, 0.8, 0) -- Green
    end
end

-- Update scoreboard
function GameUI:updateScoreboard(scores)
    if not self.scoresList then return end
    
    -- Clear existing scores
    for _, child in pairs(self.scoresList:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Add updated scores
    local yPosition = 0
    for i, score in ipairs(scores) do
        local scoreLabel = Instance.new("TextLabel")
        scoreLabel.Name = "Score" .. i
        scoreLabel.Size = UDim2.new(1, 0, 0, 25)
        scoreLabel.Position = UDim2.new(0, 0, 0, yPosition)
        scoreLabel.BackgroundTransparency = 1
        scoreLabel.Text = i .. ". " .. score.playerName .. " - " .. score.points .. " pts"
        scoreLabel.TextColor3 = Color3.new(1, 1, 1)
        scoreLabel.TextSize = 14
        scoreLabel.Font = Enum.Font.Gotham
        scoreLabel.TextXAlignment = Enum.TextXAlignment.Left
        scoreLabel.TextStrokeTransparency = 0
        scoreLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        scoreLabel.Parent = self.scoresList
        
        yPosition = yPosition + 25
    end
    
    -- Update canvas size
    self.scoresList.CanvasSize = UDim2.new(0, 0, 0, yPosition)
end

-- Show victory screen
function GameUI:showVictoryScreen(winner, finalScores)
    local victoryFrame = Instance.new("Frame")
    victoryFrame.Name = "VictoryFrame"
    victoryFrame.Size = UDim2.new(0, 500, 0, 400)
    victoryFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    victoryFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    victoryFrame.BackgroundTransparency = 0.2
    victoryFrame.BorderSizePixel = 3
    victoryFrame.BorderColor3 = Color3.new(1, 0.8, 0)
    victoryFrame.Parent = self.screenGui
    
    -- Add corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = victoryFrame
    
    -- Victory title
    local victoryTitle = Instance.new("TextLabel")
    victoryTitle.Size = UDim2.new(1, 0, 0, 80)
    victoryTitle.Position = UDim2.new(0, 0, 0, 20)
    victoryTitle.BackgroundTransparency = 1
    victoryTitle.Text = "🏆 VICTORY! 🏆"
    victoryTitle.TextColor3 = Color3.new(1, 0.8, 0)
    victoryTitle.TextScaled = true
    victoryTitle.Font = Enum.Font.FantasyItalic
    victoryTitle.TextStrokeTransparency = 0
    victoryTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
    victoryTitle.Parent = victoryFrame
    
    -- Winner announcement
    local winnerLabel = Instance.new("TextLabel")
    winnerLabel.Size = UDim2.new(1, 0, 0, 50)
    winnerLabel.Position = UDim2.new(0, 0, 0, 100)
    winnerLabel.BackgroundTransparency = 1
    winnerLabel.Text = winner .. " wins the joust!"
    winnerLabel.TextColor3 = Color3.new(1, 1, 1)
    winnerLabel.TextSize = 24
    winnerLabel.Font = Enum.Font.GothamBold
    winnerLabel.TextStrokeTransparency = 0
    winnerLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    winnerLabel.Parent = victoryFrame
    
    -- Auto-close after 5 seconds
    game:GetService("Debris"):AddItem(victoryFrame, 5)
end

-- Destroy UI
function GameUI:destroy()
    if self.screenGui then
        self.screenGui:Destroy()
    end
end

return GameUI