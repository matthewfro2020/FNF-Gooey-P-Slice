-----------------------------------------------------------
-- Main Stage [Erect Gooey] - Psych Engine 1.0.4+ Lua Stage
----------------------------------------------------------------

local pulseTimer = 0
local crowdVisible = true

----------------------------------------------------------------
-- ON CREATE: Build stage props
----------------------------------------------------------------
function onCreate()
	setProperty('defaultCamZoom', 0.85)

	----------------------------------------------------------------
	-- Solid background color (dark grey)
	----------------------------------------------------------------
	makeLuaSprite('solid', '', -500, -1000)
	makeGraphic('solid', 2400, 2000, '222026')
	setScrollFactor('solid', 0, 0)
	addLuaSprite('solid', false)

	----------------------------------------------------------------
	-- Main stage props
	----------------------------------------------------------------

	-- Bright top light
	makeLuaSprite('brightLightSmall', 'erect/brightLightSmall', 967, -103)
	setScrollFactor('brightLightSmall', 1.2, 1.2)
	setProperty('brightLightSmall.alpha', 1)
	addLuaSprite('brightLightSmall', false)

	-- Background (stage walls/floor)
	makeLuaSprite('bg', 'erect/bg', -765, -247)
	setScrollFactor('bg', 1, 1)
	addLuaSprite('bg', false)

	-- Background server racks
	makeLuaSprite('server', 'erect/server', -991, 205)
	setScrollFactor('server', 1, 1)
	addLuaSprite('server', false)

	-- Ceiling lights
	makeLuaSprite('lights', 'erect/lights', -847, -245)
	setScrollFactor('lights', 1.2, 1.2)
	addLuaSprite('lights', true)

	-- Vertical orange light beam
	makeLuaSprite('orangeLight', 'erect/orangeLight', 189, -500)
	scaleObject('orangeLight', 1, 1700)
	setProperty('orangeLight.alpha', 1)
	addLuaSprite('orangeLight', true)

	-- Left green light
	makeLuaSprite('lightgreen', 'erect/lightgreen', -171, 242)
	setProperty('lightgreen.alpha', 1)
	addLuaSprite('lightgreen', true)

	-- Lower red light
	makeLuaSprite('lightred', 'erect/lightred', -101, 560)
	setProperty('lightred.alpha', 1)
	addLuaSprite('lightred', true)

	-- Top light above characters
	makeLuaSprite('lightAbove', 'erect/lightAbove', 804, -117)
	setProperty('lightAbove.alpha', 1)
	addLuaSprite('lightAbove', true)

	----------------------------------------------------------------
	-- Crowd animations
	----------------------------------------------------------------

	-- Idle crowd
	makeAnimatedLuaSprite('crowd', 'erect/crowd', 682, 290)
	addAnimationByPrefix('crowd', 'idle', 'idle0', 12, true)
	objectPlayAnimation('crowd', 'idle', true)
	setScrollFactor('crowd', 0.8, 0.8)
	addLuaSprite('crowd', false)

	-- Gasping crowd overlay (hidden by default)
	makeAnimatedLuaSprite('crowdGasp', 'erect/week1CrowdGasp', 682, 290)
	addAnimationByPrefix('crowdGasp', 'gasp', 'bit', 12, false)
	objectPlayAnimation('crowdGasp', 'gasp', false)
	setScrollFactor('crowdGasp', 0.8, 0.8)
	setProperty('crowdGasp.alpha', 0)
	addLuaSprite('crowdGasp', true)
end

----------------------------------------------------------------
-- ON BEAT HIT: Animate crowd and pulse lights
----------------------------------------------------------------
function onBeatHit()
	if curBeat % 2 == 0 then
		objectPlayAnimation('crowd', 'idle', true)
	end

	-- Soft pulsing light to the beat
	if curBeat % 4 == 0 then
		doTweenAlpha('pulseRed', 'lightred', 0.5, 0.2, 'quadOut')
		doTweenAlpha('pulseGreen', 'lightgreen', 0.5, 0.2, 'quadOut')
		doTweenAlpha('pulseOrange', 'orangeLight', 0.6, 0.2, 'quadOut')
		runTimer('lightReturn', 0.4)
	end
end

----------------------------------------------------------------
-- RETURN LIGHT ALPHA AFTER PULSE
----------------------------------------------------------------
function onTimerCompleted(tag)
	if tag == 'lightReturn' then
		doTweenAlpha('backRed', 'lightred', 1, 0.3, 'quadIn')
		doTweenAlpha('backGreen', 'lightgreen', 1, 0.3, 'quadIn')
		doTweenAlpha('backOrange', 'orangeLight', 1, 0.3, 'quadIn')
	end
end

----------------------------------------------------------------
-- CROWD GASP EVENT (triggerable from event or chart)
----------------------------------------------------------------
function onEvent(name, value1, value2)
	if name == 'Crowd Gasp' then
		setProperty('crowdGasp.alpha', 1)
		objectPlayAnimation('crowdGasp', 'gasp', true)
		runTimer('hideGasp', 1)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'hideGasp' then
		setProperty('crowdGasp.alpha', 0)
	end
end

----------------------------------------------------------------
-- OPTIONAL: Apply shader tone to match “Erect Gooey” style
----------------------------------------------------------------
function onCreatePost()
	-- Blend mode normalization for all lights
	if getPropertyFromClass('ClientPrefs', 'shaders') then
		gooeyShaders = getDataFromSave('data', 'gooeyShaders') ~= false
	end

	if getProperty('brightLightSmall.exists') then
		setBlendMode('brightLightSmall', 'normal')
	end
	if getProperty('orangeLight.exists') then
		setBlendMode('orangeLight', 'normal')
	end
	if getProperty('lightgreen.exists') then
		setBlendMode('lightgreen', 'normal')
	end
	if getProperty('lightred.exists') then
		setBlendMode('lightred', 'normal')
	end
	if getProperty('lightAbove.exists') then
		setBlendMode('lightAbove', 'normal')
	end

	-- Crowd setup
	if getProperty('crowdGasp.exists') then
		setProperty('crowdGasp.alpha', 0)
	end
	if getProperty('crowd.exists') then
		setProperty('crowd.alpha', 1)
	end

	-- Apply shader tones (via Haxe injection)
	if gooeyShaders then
		addHaxeLibrary('AdjustColorShader', 'fun﻿kin.graphics.shaders')
		runHaxeCode([[
			var colorShaderBf = new AdjustColorShader();
			var colorShaderGf = new AdjustColorShader();
			var colorShaderDad = new AdjustColorShader();

			colorShaderBf.brightness = -23;
			colorShaderBf.hue = 12;
			colorShaderBf.contrast = 7;
			colorShaderBf.saturation = 0;

			colorShaderGf.brightness = -30;
			colorShaderGf.hue = -9;
			colorShaderGf.contrast = -4;
			colorShaderGf.saturation = 0;

			colorShaderDad.brightness = -33;
			colorShaderDad.hue = -32;
			colorShaderDad.contrast = -23;
			colorShaderDad.saturation = 0;

			if (PlayState.instance.currentSong.id.toLowerCase() == 'tutorial') {
				colorShaderDad.brightness = -30;
				colorShaderDad.hue = -9;
				colorShaderDad.contrast = -4;
			}

			// Apply shaders to characters
			if (game.boyfriend != null) game.boyfriend.shader = colorShaderBf;
			if (game.dad != null) game.dad.shader = colorShaderDad;
			if (game.gf != null) game.gf.shader = colorShaderGf;
		]])
	end
end

--------------------------------------------------------------
-- Step events for crowd reaction
--------------------------------------------------------------
function onStepHit()
	if curStep == 984 then
		if getProperty('crowdGasp.exists') then
			setProperty('crowdGasp.alpha', 1)
			objectPlayAnimation('crowdGasp', 'gasp', true)
		end
		if getProperty('crowd.exists') then
			setProperty('crowd.alpha', 0)
		end
	end

	if curStep == 1008 then
		if getProperty('crowdGasp.exists') then
			setProperty('crowdGasp.alpha', 0)
		end
		if getProperty('crowd.exists') then
			setProperty('crowd.alpha', 1)
		end
	end
end

--------------------------------------------------------------
-- Reset crowd on song restart
--------------------------------------------------------------
function onSongRetry()
	if getProperty('crowdGasp.exists') then
		setProperty('crowdGasp.alpha', 0)
	end
	if getProperty('crowd.exists') then
		setProperty('crowd.alpha', 1)
	end
end

--------------------------------------------------------------
-- Placeholder for beat logic (expandable)
--------------------------------------------------------------
function onBeatHit()
	-- You can pulse lights here if desired
end