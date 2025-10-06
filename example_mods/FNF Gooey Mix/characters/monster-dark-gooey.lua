-- Psych Engine character script (auto-converted)
-- Character: monster-dark-gooey
-- Image: characters/Monster_Assets_darkGooey
-- This script sets camera offsets, icon, flip, and exposes animation offsets for tuning.
-- Drop into mods/characters/monster-dark-gooey.lua

local CHAR = "monster-dark-gooey"
local offsets = {}

function onCreatePost()
  -- Apply camera offsets and icon if this character is in play
  if getProperty('boyfriend.curCharacter') == CHAR then
    setProperty('boyfriendCameraOffset', {20, 70})
    setProperty('iconP1', 'gooey')
    setProperty('boyfriend.flipX', true)
    setProperty('boyfriend.scale.x', 1); setProperty('boyfriend.scale.y', 1)
  end
  if getProperty('dad.curCharacter') == CHAR then
    setProperty('dadCameraOffset', {20, 70})
    setProperty('iconP2', 'gooey')
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
  offsets["idle-hold"] = {0, 0}
  offsets["singLEFT"] = {-30, 20}
  offsets["singLEFT-hold"] = {-30, 20}
  offsets["singDOWN"] = {-50, -80}
  offsets["singDOWN-hold"] = {-50, -80}
  offsets["singUP"] = {-20, 94}
  offsets["singUP-hold"] = {-20, 94}
  offsets["singRIGHT"] = {-51, 30}
  offsets["singRIGHT-hold"] = {-51, 30}

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
