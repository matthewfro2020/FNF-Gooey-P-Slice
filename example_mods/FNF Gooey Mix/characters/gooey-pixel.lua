-- Psych Engine character script (auto-converted)
-- Character: gooey-pixel
-- Image: characters/gooey/gooeyPixel
-- This script sets camera offsets, icon, flip, and exposes animation offsets for tuning.
-- Drop into mods/characters/gooey-pixel.lua

local CHAR = "gooey-pixel"
local offsets = {}

function onCreatePost()
  -- Apply camera offsets and icon if this character is in play
  if getProperty('boyfriend.curCharacter') == CHAR then
    setProperty('boyfriendCameraOffset', {20, 70})
    setProperty('iconP1', 'gooey-pixel')
    setProperty('boyfriend.flipX', true)
    setProperty('boyfriend.scale.x', 6); setProperty('boyfriend.scale.y', 6)
  end
  if getProperty('dad.curCharacter') == CHAR then
    setProperty('dadCameraOffset', {20, 70})
    setProperty('iconP2', 'gooey-pixel')
    setProperty('dad.flipX', true)
    setProperty('dad.scale.x', 6); setProperty('dad.scale.y', 6)
  end
  if getProperty('gf.curCharacter') == CHAR then
    setProperty('gfCameraOffset', {20, 70})
    setProperty('gf.flipX', true)
    setProperty('gf.scale.x', 6); setProperty('gf.scale.y', 6)
  end

-- Animation offsets map
  offsets["idle"] = {0, 0}
  offsets["singLEFT"] = {0, 0}
  offsets["singDOWN"] = {0, 0}
  offsets["singUP"] = {0, 0}
  offsets["singRIGHT"] = {0, 0}
  offsets["singLEFTmiss"] = {0, 0}
  offsets["singDOWNmiss"] = {0, 0}
  offsets["singUPmiss"] = {0, 0}
  offsets["singRIGHTmiss"] = {0, 0}
  offsets["firstDeath"] = {0, 0}
  offsets["deathLoop"] = {0, 0}
  offsets["deathConfirm"] = {0, 0}

  -- Apply known animation offsets to the live sprite (optional, safe-guarded)
  for anim, off in pairs(offsets) do
    if getProperty('dad.curCharacter') == CHAR then addOffset('dad', anim, off[1], off[2]) end
    if getProperty('boyfriend.curCharacter') == CHAR then addOffset('boyfriend', anim, off[1], off[2]) end
    if getProperty('gf.curCharacter') == CHAR then addOffset('gf', anim, off[1], off[2]) end
  end
end

-- Hooks available for custom logic; extend as needed
function onBeatHit() end
function onStepHit() end
function onUpdate(elapsed) end
