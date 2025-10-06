-- Psych Engine character script (auto-converted)
-- Character: gooey-dark
-- Image: characters/gooey/Gooey_dark
-- This script sets camera offsets, icon, flip, and exposes animation offsets for tuning.
-- Drop into mods/characters/gooey-dark.lua

local CHAR = "gooey-dark"
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
  offsets["idle"] = {12, -110}
  offsets["singLEFT"] = {12, -110}
  offsets["singDOWN"] = {12, -110}
  offsets["singUP"] = {12, -110}
  offsets["singRIGHT"] = {12, -110}
  offsets["singLEFTmiss"] = {12, -110}
  offsets["singDOWNmiss"] = {12, -110}
  offsets["singUPmiss"] = {12, -110}
  offsets["singRIGHTmiss"] = {12, -110}
  offsets["dodge"] = {12, -110}
  offsets["hey"] = {12, -110}
  offsets["cheer"] = {12, -110}
  offsets["scared"] = {12, -110}
  offsets["burp"] = {12, -110}
  offsets["firstDeath"] = {12, -110}
  offsets["deathLoop"] = {12, -110}
  offsets["deathConfirm"] = {12, -110}

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
