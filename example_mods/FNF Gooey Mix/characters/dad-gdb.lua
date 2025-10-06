-- Psych Engine character script (auto-converted)
-- Character: dad-gdb
-- Image: characters/daddyDearest
-- This script sets camera offsets, icon, flip, and exposes animation offsets for tuning.
-- Drop into mods/characters/dad-gdb.lua

local CHAR = "dad-gdb"
local offsets = {}

function onCreatePost()
  -- Apply camera offsets and icon if this character is in play
  if getProperty('boyfriend.curCharacter') == CHAR then
    setProperty('boyfriendCameraOffset', {20, 70})
    setProperty('iconP1', 'dad')
    setProperty('boyfriend.flipX', true)
    setProperty('boyfriend.scale.x', 1); setProperty('boyfriend.scale.y', 1)
  end
  if getProperty('dad.curCharacter') == CHAR then
    setProperty('dadCameraOffset', {20, 70})
    setProperty('iconP2', 'dad')
    setProperty('dad.flipX', true)
    setProperty('dad.scale.x', 1); setProperty('dad.scale.y', 1)
  end
  if getProperty('gf.curCharacter') == CHAR then
    setProperty('gfCameraOffset', {20, 70})
    setProperty('gf.flipX', true)
    setProperty('gf.scale.x', 1); setProperty('gf.scale.y', 1)
  end

-- Animation offsets map
  offsets["idle"] = {0, 0}
  offsets["hurt"] = {396, 384}
  offsets["pissed"] = {396, 384}
  offsets["idle-hold"] = {0, 0}
  offsets["singLEFT"] = {-10, 10}
  offsets["singLEFT-hold"] = {-10, 10}
  offsets["singDOWN"] = {0, -30}
  offsets["singDOWN-hold"] = {0, -30}
  offsets["singUP"] = {-6, 50}
  offsets["singUP-hold"] = {-6, 50}
  offsets["singRIGHT"] = {0, 27}
  offsets["singRIGHT-hold"] = {0, 27}

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
