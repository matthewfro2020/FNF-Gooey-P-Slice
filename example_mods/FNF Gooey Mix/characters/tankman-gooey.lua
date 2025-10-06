-- Psych Engine character script (auto-converted)
-- Character: tankman-gooey
-- Image: characters/tankmanCaptain
-- This script sets camera offsets, icon, flip, and exposes animation offsets for tuning.
-- Drop into mods/characters/tankman-gooey.lua

local CHAR = "tankman-gooey"
local offsets = {}

function onCreatePost()
  -- Apply camera offsets and icon if this character is in play
  if getProperty('boyfriend.curCharacter') == CHAR then
    setProperty('boyfriendCameraOffset', {0, 0})
    setProperty('iconP1', 'tankman')
    setProperty('boyfriend.flipX', true)
    setProperty('boyfriend.scale.x', 1); setProperty('boyfriend.scale.y', 1)
  end
  if getProperty('dad.curCharacter') == CHAR then
    setProperty('dadCameraOffset', {0, 0})
    setProperty('iconP2', 'tankman')
    setProperty('dad.flipX', true)
    setProperty('dad.scale.x', 1); setProperty('dad.scale.y', 1)
  end
  if getProperty('gf.curCharacter') == CHAR then
    setProperty('gfCameraOffset', {0, 0})
    setProperty('gf.flipX', true)
    setProperty('gf.scale.x', 1); setProperty('gf.scale.y', 1)
  end

-- Animation offsets map
  offsets["idle"] = {0, 0}
  offsets["dankman"] = {40, 10}
  offsets["done"] = {0, 10}
  offsets["singLEFT"] = {90, -13}
  offsets["singDOWN"] = {63, -105}
  offsets["singUP"] = {48, 54}
  offsets["singRIGHT"] = {-22, -28}
  offsets["augh"] = {52, -6}
  offsets["ugh"] = {-16, -9}
  offsets["fuck"] = {-2, 15}
  offsets["isGooey"] = {-2, 15}
  offsets["idle-gooey"] = {0, 0}
  offsets["singLEFT-gooey"] = {90, -13}
  offsets["singDOWN-gooey"] = {63, -105}
  offsets["singUP-gooey"] = {48, 54}
  offsets["singRIGHT-gooey"] = {-22, -28}

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
