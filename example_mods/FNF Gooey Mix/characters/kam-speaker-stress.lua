-- Psych Engine character script (auto-converted)
-- Character: kam-speaker-stress
-- Image: characters/kam/KamStress
-- This script sets camera offsets, icon, flip, and exposes animation offsets for tuning.
-- Drop into mods/characters/kam-speaker-stress.lua

local CHAR = "kam-speaker-stress"
local offsets = {}

function onCreatePost()
  -- Apply camera offsets and icon if this character is in play
  if getProperty('boyfriend.curCharacter') == CHAR then
    setProperty('boyfriendCameraOffset', {20, 70})
    setProperty('iconP1', 'kam')
    setProperty('boyfriend.flipX', true)
    setProperty('boyfriend.scale.x', 1); setProperty('boyfriend.scale.y', 1)
  end
  if getProperty('dad.curCharacter') == CHAR then
    setProperty('dadCameraOffset', {20, 70})
    setProperty('iconP2', 'kam')
    setProperty('dad.flipX', true)
    setProperty('dad.scale.x', 1); setProperty('dad.scale.y', 1)
  end
  if getProperty('gf.curCharacter') == CHAR then
    setProperty('gfCameraOffset', {20, 70})
    setProperty('gf.flipX', true)
    setProperty('gf.scale.x', 1); setProperty('gf.scale.y', 1)
  end

-- Animation offsets map
  offsets["shoot1"] = {0, 0}
  offsets["shoot2"] = {0, 0}
  offsets["shoot3"] = {0, 0}
  offsets["shoot4"] = {0, 0}
  offsets["idle"] = {0, 0}
  offsets["fakeIdle"] = {0, 0}
  offsets["kamMurder"] = {0, 0}
  offsets["grab"] = {0, 0}
  offsets["iDontKnow"] = {0, 0}

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
