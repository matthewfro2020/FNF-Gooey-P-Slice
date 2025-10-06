-- Psych Engine character script (auto-converted)
-- Character: flora-speakerless
-- Image: characters/flora/Flora
-- This script sets camera offsets, icon, flip, and exposes animation offsets for tuning.
-- Drop into mods/characters/flora-speakerless.lua

local CHAR = "flora-speakerless"
local offsets = {}

function onCreatePost()
  -- Apply camera offsets and icon if this character is in play
  if getProperty('boyfriend.curCharacter') == CHAR then
    setProperty('boyfriendCameraOffset', {0, 0})
    setProperty('iconP1', 'flora')
    setProperty('boyfriend.flipX', true)
    setProperty('boyfriend.scale.x', 1); setProperty('boyfriend.scale.y', 1)
  end
  if getProperty('dad.curCharacter') == CHAR then
    setProperty('dadCameraOffset', {0, 0})
    setProperty('iconP2', 'flora')
    setProperty('dad.flipX', true)
    setProperty('dad.scale.x', 1); setProperty('dad.scale.y', 1)
  end
  if getProperty('gf.curCharacter') == CHAR then
    setProperty('gfCameraOffset', {0, 0})
    setProperty('gf.flipX', true)
    setProperty('gf.scale.x', 1); setProperty('gf.scale.y', 1)
  end

-- Animation offsets map
  offsets["danceLeft"] = {-20, 180}
  offsets["danceRight"] = {-20, 180}
  offsets["combo50"] = {-20, 180}
  offsets["combo200"] = {-20, 180}
  offsets["drop70"] = {-20, 180}
  offsets["scared"] = {-20, 180}

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
