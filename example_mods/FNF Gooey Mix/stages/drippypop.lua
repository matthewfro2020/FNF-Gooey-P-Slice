----------------------------------------------------------------
-- DrippyPop Erect Stage (Lua version of the Haxe class)
-- Gooey Mix Edition • Psych Engine v1.0.4+
----------------------------------------------------------------

local mist0 = nil
local mist1 = nil
local mist2 = nil
local timer = 0
local shadersEnabled = true

function onCreate()
    -- Set camera zoom
    setProperty('defaultCamZoom', 0.9)

    ----------------------------------------------------------------
    -- BACKGROUND LAYERS
    ----------------------------------------------------------------

    -- Back wall / alley
    makeLuaSprite('Alley', 'gooeyMix/extra/drip/ngErect', -260, -650)
    setScrollFactor('Alley', 1, 1)
    scaleObject('Alley', 1, 1)
    addLuaSprite('Alley', false)

    -- Animated background characters (drippers)
    makeAnimatedLuaSprite('Drippers', 'gooeyMix/extra/drip/drippersErect', -50, -430)
    addAnimationByPrefix('Drippers', 'idle', 'drippers', 12, true)
    objectPlayAnimation('Drippers', 'idle', true)
    setScrollFactor('Drippers', 1, 1)
    scaleObject('Drippers', 1, 1)
    addLuaSprite('Drippers', false)

    -- Shading overlay
    makeLuaSprite('Shading', 'gooeyMix/extra/drip/erectShade', -260, -650)
    setScrollFactor('Shading', 1, 1)
    scaleObject('Shading', 1, 1)
    addLuaSprite('Shading', true)

	-- === Mist layers ===
	makeLuaSprite('mist0', 'gooeyMix/extra/drip/mistBack', -650, -700)
	setScrollFactor('mist0', 1.2, 1.2)
	setProperty('mist0.alpha', 0.6)
	scaleObject('mist0', 1, 1)
	addLuaSprite('mist0', true)

	makeLuaSprite('mist1', 'gooeyMix/extra/drip/mistBack', -650, -700)
	setScrollFactor('mist1', 1.1, 1.1)
	setProperty('mist1.alpha', 0.6)
	scaleObject('mist1', 1, 1)
	addLuaSprite('mist1', true)

	makeLuaSprite('mist2', 'gooeyMix/extra/drip/mistMid', -650, -700)
	setScrollFactor('mist2', 0.95, 0.95)
	setProperty('mist2.alpha', 0.5)
	scaleObject('mist2', 0.8, 0.8)
	addLuaSprite('mist2', true)

	-- Store names for update loop
	mist0 = 'mist0'
	mist1 = 'mist1'
	mist2 = 'mist2'

	-- === Color shader setup ===
	-- requires the AdjustColorShader library
	addHaxeLibrary('AdjustColorShader', 'fun﻿kin.graphics.shaders')
	runHaxeCode([[
		if (game.getLuaObject('boyfriend') != null)
		{
			var colorShaderBf = new AdjustColorShader();
			colorShaderBf.brightness = -5;
			colorShaderBf.hue = -26;
			colorShaderBf.contrast = 0;
			colorShaderBf.saturation = -12;
			game.boyfriend.shader = colorShaderBf;

			var colorShaderGf = new AdjustColorShader();
			colorShaderGf.brightness = -5;
			colorShaderGf.hue = -26;
			colorShaderGf.contrast = 0;
			colorShaderGf.saturation = -12;
			game.gf.shader = colorShaderGf;

			var colorShaderDad = new AdjustColorShader();
			colorShaderDad.brightness = -5;
			colorShaderDad.hue = -26;
			colorShaderDad.contrast = 0;
			colorShaderDad.saturation = -12;
			game.dad.shader = colorShaderDad;
		}
	]])
end
----------------------------------------------------------------
-- ON UPDATE: Mist Motion and Shader Recheck
----------------------------------------------------------------
function onUpdate(elapsed)
	timer = timer + elapsed

	-- Mist bobbing motion
	setProperty(mist0 .. '.y', 60 + math.sin(timer * 0.35) * 70)
	setProperty(mist1 .. '.y', -100 + math.sin(timer * 0.3) * 80)
	setProperty(mist2 .. '.y', -430 + math.sin(timer * 0.3) * 70)

	-- Reapply shaders if something removes them
	if shadersEnabled then
		runHaxeCode([[
			if (game.boyfriend.shader == null)
			{
				var colorShaderBf = new AdjustColorShader();
				colorShaderBf.brightness = -5;
				colorShaderBf.hue = -26;
				colorShaderBf.contrast = 0;
				colorShaderBf.saturation = -12;
				game.boyfriend.shader = colorShaderBf;
			}
			if (game.gf.shader == null)
			{
				var colorShaderGf = new AdjustColorShader();
				colorShaderGf.brightness = -5;
				colorShaderGf.hue = -26;
				colorShaderGf.contrast = 0;
				colorShaderGf.saturation = -12;
				game.gf.shader = colorShaderGf;
			}
			if (game.dad.shader == null)
			{
				var colorShaderDad = new AdjustColorShader();
				colorShaderDad.brightness = -5;
				colorShaderDad.hue = -26;
				colorShaderDad.contrast = 0;
				colorShaderDad.saturation = -12;
				game.dad.shader = colorShaderDad;
			}
		]])
	end
end

end

----------------------------------------------------------------
-- ON BEAT HIT: Trigger any looping or dancing animations
----------------------------------------------------------------
function onBeatHit()
    if curBeat % 2 == 0 then
        objectPlayAnimation('Drippers', 'idle', true)
    end
    if curBeat <= 283 then
	characterPlayAnim('gf', 'idle-alt', false)
    end
end

----------------------------------------------------------------
-- ON COUNTDOWN START
----------------------------------------------------------------
function onCountdownStarted()
	characterPlayAnim('gf', 'idle-alt', false)
end

----------------------------------------------------------------
-- CUSTOM NOTE HANDLER (GF Sing)
----------------------------------------------------------------
function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'gfsing' and mustHitSection == true then
		local dirs = {'LEFT', 'DOWN', 'UP', 'RIGHT'}
		local anim = 'sing' .. dirs[direction + 1]
		characterPlayAnim('gf', anim, true)
	end
end