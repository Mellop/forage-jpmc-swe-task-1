-- Roblox Jousting Game - Configuration File
-- This file contains all the configurable settings for the game

local Config = {}

-- Game Settings
Config.GAME = {
    MAX_PLAYERS = 8,              -- Maximum number of players in a match
    ROUND_TIME = 180,             -- Round duration in seconds (3 minutes)
    RESPAWN_TIME = 5,             -- Time before player respawns after death
    MIN_PLAYERS_TO_START = 2,     -- Minimum players needed to start a round
    VICTORY_CONDITION = "last_standing", -- "last_standing", "time_limit", or "score_limit"
    SCORE_LIMIT = 500,            -- Points needed to win (if using score_limit)
}

-- Arena Settings
Config.ARENA = {
    SIZE = 200,                   -- Arena diameter/width
    WALL_HEIGHT = 10,             -- Height of arena walls
    WALL_THICKNESS = 2,           -- Thickness of arena walls
    SPAWN_RADIUS = 60,            -- Distance of spawn points from center
}

-- Player/Horse Settings
Config.PLAYER = {
    MAX_HEALTH = 100,             -- Starting health for players
    HORSE_SPEED = 30,             -- Base horse movement speed
    TURN_SPEED = 5,               -- Horse turning rate
    CHARGE_SPEED_MULTIPLIER = 1.5,-- Speed boost when charging
}

-- Combat Settings
Config.COMBAT = {
    LANCE_REACH = 10,             -- Base attack range
    LANCE_DAMAGE = 20,            -- Base lance damage
    CHARGE_DAMAGE_MULTIPLIER = 1.75, -- Damage boost when charging
    CHARGE_REACH_MULTIPLIER = 1.5,   -- Range boost when charging
    HIT_POINTS = 10,              -- Points for hitting opponent
    ELIMINATION_BONUS = 50,       -- Bonus points for eliminating opponent
    CHARGE_HIT_BONUS = 10,        -- Extra points for charge attacks
}

-- Visual Settings
Config.VISUAL = {
    SHOW_CROSSHAIR = true,        -- Display crosshair
    SHOW_HEALTH_BAR = true,       -- Display health bar
    SHOW_CHARGE_METER = true,     -- Display charge meter
    SHOW_LEADERBOARD = true,      -- Display real-time scores
    SHOW_CONTROLS = true,         -- Display control instructions
    PARTICLE_EFFECTS = true,      -- Enable particle effects
}

-- Audio Settings
Config.AUDIO = {
    MASTER_VOLUME = 0.5,          -- Overall game volume (0.0 to 1.0)
    SFX_VOLUME = 0.7,             -- Sound effects volume
    MUSIC_VOLUME = 0.3,           -- Background music volume
    ENABLE_COMBAT_SOUNDS = true,  -- Enable hit/miss sounds
    ENABLE_HORSE_SOUNDS = true,   -- Enable horse galloping/neighing
    ENABLE_CROWD_SOUNDS = true,   -- Enable crowd cheering
}

-- Performance Settings
Config.PERFORMANCE = {
    MAX_PARTICLES = 50,           -- Maximum particle effects on screen
    LOD_DISTANCE = 100,           -- Level of detail distance
    SHADOW_QUALITY = "Medium",    -- "Low", "Medium", "High"
    TEXTURE_QUALITY = "Medium",   -- "Low", "Medium", "High"
}

-- Debug Settings
Config.DEBUG = {
    SHOW_HIT_BOXES = false,       -- Show collision detection boxes
    SHOW_SPAWN_POINTS = false,    -- Highlight spawn locations
    PRINT_DAMAGE_NUMBERS = true,  -- Print damage to console
    SHOW_FPS = false,             -- Display FPS counter
    ENABLE_CHEATS = false,        -- Enable debug commands
}

-- Color Schemes
Config.COLORS = {
    PRIMARY = Color3.new(0.8, 0.6, 0),    -- Gold/Yellow theme color
    SECONDARY = Color3.new(0.5, 0.3, 0.1), -- Brown accent color
    HEALTH_GOOD = Color3.new(0, 0.8, 0),   -- Green for high health
    HEALTH_MEDIUM = Color3.new(1, 0.8, 0), -- Orange for medium health
    HEALTH_LOW = Color3.new(0.8, 0, 0),    -- Red for low health
    CHARGE_COLOR = Color3.new(1, 0.5, 0),  -- Orange for charge effects
    HIT_EFFECT = Color3.new(1, 1, 0),      -- Yellow for hit effects
}

-- Input Settings
Config.INPUT = {
    MOVE_FORWARD = Enum.KeyCode.W,
    MOVE_BACKWARD = Enum.KeyCode.S,
    TURN_LEFT = Enum.KeyCode.A,
    TURN_RIGHT = Enum.KeyCode.D,
    CHARGE = Enum.KeyCode.LeftShift,
    ATTACK_PRIMARY = Enum.KeyCode.Space,
    ATTACK_SECONDARY = Enum.UserInputType.MouseButton1,
}

-- Validation function to ensure config values are reasonable
function Config.validate()
    -- Clamp values to reasonable ranges
    Config.GAME.MAX_PLAYERS = math.max(2, math.min(20, Config.GAME.MAX_PLAYERS))
    Config.ARENA.SIZE = math.max(50, math.min(500, Config.ARENA.SIZE))
    Config.PLAYER.MAX_HEALTH = math.max(50, math.min(500, Config.PLAYER.MAX_HEALTH))
    Config.COMBAT.LANCE_DAMAGE = math.max(10, math.min(100, Config.COMBAT.LANCE_DAMAGE))
    
    -- Volume validation
    Config.AUDIO.MASTER_VOLUME = math.max(0, math.min(1, Config.AUDIO.MASTER_VOLUME))
    Config.AUDIO.SFX_VOLUME = math.max(0, math.min(1, Config.AUDIO.SFX_VOLUME))
    Config.AUDIO.MUSIC_VOLUME = math.max(0, math.min(1, Config.AUDIO.MUSIC_VOLUME))
    
    return true
end

-- Get a configuration value with optional default
function Config.get(key, default)
    local keys = string.split(key, ".")
    local current = Config
    
    for _, k in ipairs(keys) do
        if current[k] ~= nil then
            current = current[k]
        else
            return default
        end
    end
    
    return current
end

-- Update a configuration value
function Config.set(key, value)
    local keys = string.split(key, ".")
    local current = Config
    
    for i = 1, #keys - 1 do
        local k = keys[i]
        if current[k] == nil then
            current[k] = {}
        end
        current = current[k]
    end
    
    current[keys[#keys]] = value
end

-- Initialize configuration
Config.validate()

return Config