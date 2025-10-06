-- Psych Engine character script (auto-converted)
-- Character: bf-gooey
-- Image: characters/BOYFRIEND
-- This script sets camera offsets, icon, flip, and exposes animation offsets for tuning.
-- Drop into mods/characters/bf-gooey.lua

local CHAR = "bf-gooey"
local offsets = {}

function onCreatePost()
  -- Apply camera offsets and icon if this character is in play
  if getProperty('boyfriend.curCharacter') == CHAR then
    setProperty('boyfriendCameraOffset', {20, 70})
    setProperty('iconP1', 'bf')
    setProperty('boyfriend.flipX', true)
    setProperty('boyfriend.scale.x', 1); setProperty('boyfriend.scale.y', 1)
  end
  if getProperty('dad.curCharacter') == CHAR then
    setProperty('dadCameraOffset', {20, 70})
    setProperty('iconP2', 'bf')
    setProperty('dad.flipX', true)
    setProperty('dad.scale.x', 1); setProperty('dad.scale.y', 1)
  end
  if getProperty('gf.curCharacter') == CHAR then
    setProperty('gfCameraOffset', {20, 70})
    setProperty('gf.flipX', true)
    setProperty('gf.scale.x', 1); setProperty('gf.scale.y', 1)
  end

-- Animation offsets map
  offsets["idle"] = {-5, 0}
  offsets["singLEFT"] = {12, -6}
  offsets["singDOWN"] = {-10, -50}
  offsets["singUP"] = {-29, 27}
  offsets["singRIGHT"] = {-38, -7}
  offsets["singLEFTmiss"] = {12, 24}
  offsets["singDOWNmiss"] = {-11, -19}
  offsets["singUPmiss"] = {-29, 27}
  offsets["singRIGHTmiss"] = {-30, 21}
  offsets["preAttack"] = {0, 0}
  offsets["attack"] = {0, 0}
  offsets["dodge"] = {0, 0}
  offsets["dodge-hold"] = {0, 0}
  offsets["hey"] = {7, 4}
  offsets["cheer"] = {0, 0}
  offsets["hit"] = {0, 0}
  offsets["hit-hold"] = {0, 0}
  offsets["firstDeath"] = {-37, 11}
  offsets["fakeoutDeath"] = {-37, 11}
  offsets["deathLoop"] = {-37, 5}
  offsets["deathConfirm"] = {-37, 69}
  offsets["scared"] = {-4, 0}

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
