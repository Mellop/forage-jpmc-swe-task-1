# Sound Effects Directory

This directory is intended for audio files used in the Roblox Jousting Game.

## Recommended Sound Effects

### Combat Sounds
- **lance_hit.mp3** - Sound when lance successfully hits opponent
- **lance_miss.mp3** - Sound when lance attack misses
- **armor_clank.mp3** - Metal armor collision sounds

### Horse Sounds
- **horse_gallop.mp3** - Horse running/galloping sound
- **horse_neigh.mp3** - Horse vocal sounds
- **hooves.mp3** - Hoof beats on different surfaces

### Ambient Sounds
- **crowd_cheer.mp3** - Crowd cheering for successful hits
- **trumpet_fanfare.mp3** - Victory/round start fanfare
- **medieval_ambience.mp3** - Background medieval atmosphere

### UI Sounds
- **button_click.mp3** - Menu/UI interaction sounds
- **score_increase.mp3** - Points scored notification
- **round_start.mp3** - Round beginning sound

## Audio Requirements

- **Format**: MP3 or OGG for best Roblox compatibility
- **Quality**: 22kHz sample rate recommended for balance of quality/file size
- **Volume**: Normalize audio levels to prevent sudden loud sounds
- **Length**: Keep effect sounds under 5 seconds for responsiveness

## How to Add Sounds

1. Add audio files to this directory
2. Upload to Roblox as audio assets
3. Reference in scripts using the asset ID:
   ```lua
   local sound = Instance.new("Sound")
   sound.SoundId = "rbxassetid://YOUR_AUDIO_ID"
   sound.Parent = workspace
   sound:Play()
   ```

## Current Status

⚠️ **This directory currently contains placeholder content.** The game scripts include sound playback functionality, but audio files need to be added and uploaded to Roblox to be functional.

## Audio Implementation Example

```lua
-- Example from GameManager.lua
local function playHitSound()
    local hitSound = Instance.new("Sound")
    hitSound.SoundId = "rbxassetid://131961136" -- Example ID
    hitSound.Volume = 0.5
    hitSound.Parent = workspace
    hitSound:Play()
    hitSound.Ended:Connect(function()
        hitSound:Destroy()
    end)
end
```