----------------------------------------------------------------
-- Limo Ride Erect Gooey Stage (Lua version)
-- Psych Engine v1.0.4+
----------------------------------------------------------------

local mist = {}
local timer = 0
local doCarHaptics = false
local fastCarCanDrive = false
local shootingStarBeat = 0
local shootingStarOffset = 2
local gooeyShaders = true

----------------------------------------------------------------
-- ON CREATE: Build stage props
----------------------------------------------------------------
function onCreate()
	setProperty('defaultCamZoom', 0.9)

	----------------------------------------------------------------
	-- PROPS FROM JSON
	----------------------------------------------------------------
	-- Background sky
	makeLuaSprite('limoSunset', 'limo/erect/limoSunset', -220, -80)
	setScrollFactor('limoSunset', 0.1, 0.1)
	scaleObject('limoSunset', 0.9, 0.9)
	addLuaSprite('limoSunset', false)

	-- Shooting star
	makeAnimatedLuaSprite('shootingStar', 'limo/erect/shooting star', 200, 0)
	addAnimationByPrefix('shootingStar', 'shooting star', 'shooting star', 24, false)
	objectPlayAnimation('shootingStar', 'shooting star', false)
	setScrollFactor('shootingStar', 0.12, 0.12)
	addLuaSprite('shootingStar', false)

	-- Background limo
	makeAnimatedLuaSprite('bgLimo', 'limo/erect/bgLimo', -200, 480)
	addAnimationByPrefix('bgLimo', 'drive', 'background limo blue', 24, true)
	objectPlayAnimation('bgLimo', 'drive', true)
	setScrollFactor('bgLimo', 0.4, 0.4)
	addLuaSprite('bgLimo', false)

	-- Front limo
	makeAnimatedLuaSprite('limo', 'limo/erect/limoDrive', -120, 520)
	addAnimationByPrefix('limo', 'drive', 'Limo stage', 24, true)
	objectPlayAnimation('limo', 'drive', true)
	setScrollFactor('limo', 1, 1)
	addLuaSprite('limo', false)

	-- Fast car
	makeLuaSprite('fastCar', 'limo/fastCarLol', -12600, 160)
	setScrollFactor('fastCar', 1, 1)
	addLuaSprite('fastCar', true)

	-- Henchmen dancers
	for i = 1, 5 do
		local dancerName = 'limoDancer' .. i
		local xPos = (i - 1) * 300 + 100
		makeAnimatedLuaSprite(dancerName, 'limo/henchmen', xPos, 100)
		addAnimationByIndices(dancerName, 'danceLeft', 'hench dancing', '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14', 24)
		addAnimationByIndices(dancerName, 'danceRight', 'hench dancing', '15,16,17,18,19,20,21,22,23,24,25,26,27,28,29', 24)
		addAnimationByPrefix(dancerName, 'hit1', 'hench hit 1', 24, false)
		addAnimationByPrefix(dancerName, 'hit2', 'hench hit 2', 24, false)
		objectPlayAnimation(dancerName, 'danceLeft', true)
		setScrollFactor(dancerName, 0.4, 0.4)
		addLuaSprite(dancerName, false)
	end

	----------------------------------------------------------------
	-- MIST LAYERS
	----------------------------------------------------------------
	makeLuaSprite('mist1', 'limo/erect/mistMid', -650, -100)
	setScrollFactor('mist1', 1.1, 1.1)
	setProperty('mist1.alpha', 0.4)
	addLuaSprite('mist1', true)
	mist[1] = 'mist1'

	makeLuaSprite('mist2', 'limo/erect/mistBack', -650, -100)
	setScrollFactor('mist2', 1.2, 1.2)
	setProperty('mist2.alpha', 1)
	scaleObject('mist2', 1.3, 1.3)
	addLuaSprite('mist2', true)
	mist[2] = 'mist2'

	makeLuaSprite('mist3', 'limo/erect/mistMid', -650, -100)
	setScrollFactor('mist3', 0.8, 0.8)
	setProperty('mist3.alpha', 0.5)
	scaleObject('mist3', 1.5, 1.5)
	addLuaSprite('mist3', true)
	mist[3] = 'mist3'

	makeLuaSprite('mist4', 'limo/erect/mistBack', -650, -380)
	setScrollFactor('mist4', 0.6, 0.6)
	setProperty('mist4.alpha', 1)
	scaleObject('mist4', 1.5, 1.5)
	addLuaSprite('mist4', true)
	mist[4] = 'mist4'

	makeLuaSprite('mist5', 'limo/erect/mistMid', -650, -400)
	setScrollFactor('mist5', 0.2, 0.2)
	setProperty('mist5.alpha', 1)
	scaleObject('mist5', 1.5, 1.5)
	addLuaSprite('mist5', true)
	mist[5] = 'mist5'
end

----------------------------------------------------------------
-- ON CREATE POST: Apply shaders and overlay
----------------------------------------------------------------
function onCreatePost()
	if getDataFromSave('data', 'gooeyShaders') ~= false then
		addHaxeLibrary('OverlayBlend', 'fun﻿kin.graphics.shaders')
		runHaxeCode([[
			var skyOverlay = new OverlayBlend();
			var sunOverlay = new flixel.FlxSprite().loadGraphic(Paths.image('limo/limoOverlay'));
			sunOverlay.setGraphicSize(Std.int(sunOverlay.width * 2));
			sunOverlay.updateHitbox();
			skyOverlay.funnyShit.input = sunOverlay.pixels;
			var limoSunset = game.getLuaObject('limoSunset');
			if (limoSunset != null) limoSunset.shader = skyOverlay;
		]])

		addHaxeLibrary('AdjustColorShader', 'fun﻿kin.graphics.shaders')
		runHaxeCode([[
			var colorShader = new AdjustColorShader();
			colorShader.hue = -30;
			colorShader.saturation = -20;
			colorShader.contrast = 0;
			colorShader.brightness = -30;
			for (name in ['limoDancer1','limoDancer2','limoDancer3','limoDancer4','limoDancer5','fastCar'])
			{
				var obj = game.getLuaObject(name);
				if (obj != null) obj.shader = colorShader;
			}
			for (char in [game.boyfriend, game.gf, game.dad])
			{
				if (char != null) char.shader = colorShader;
			}
		]])
	end

	setBlendMode('shootingStar', 'normal')
	resetFastCar()
end

----------------------------------------------------------------
-- FAST CAR & SHOOTING STAR
----------------------------------------------------------------
function resetFastCar()
	if luaSpriteExists('fastCar') then
		setProperty('fastCar.active', true)
		setProperty('fastCar.x', -12600)
		setProperty('fastCar.y', getRandomInt(140, 250))
		setProperty('fastCar.velocity.x', 0)
		fastCarCanDrive = true
	end
end

function fastCarDrive()
	if not luaSpriteExists('fastCar') then return end
	playSound('carPass' .. getRandomInt(0, 1), 0.7)
	setProperty('fastCar.velocity.x', (getRandomInt(170, 220) / getPropertyFromClass('flixel.FlxG', 'elapsed')) * 3)
	fastCarCanDrive = false
	runTimer('resetCar', 2)
end

function onTimerCompleted(tag)
	if tag == 'resetCar' then
		resetFastCar()
	end
end

function doShootingStar(beat)
	if not luaSpriteExists('shootingStar') then return end
	setProperty('shootingStar.x', getRandomInt(50, 900))
	setProperty('shootingStar.y', getRandomInt(-10, 20))
	setProperty('shootingStar.flipX', getRandomBool(50))
	objectPlayAnimation('shootingStar', 'shooting star', true)
	shootingStarBeat = beat
	shootingStarOffset = getRandomInt(4, 8)
end

----------------------------------------------------------------
-- BEAT + UPDATE HANDLING
----------------------------------------------------------------
function onBeatHit()
	if getRandomBool(10) and fastCarCanDrive then fastCarDrive() end
	if getRandomBool(10) and curBeat > (shootingStarBeat + shootingStarOffset) then
		doShootingStar(curBeat)
	end
	for i = 1, 5 do
		local dancer = 'limoDancer' .. i
		if getProperty(dancer .. '.animation.curAnim.name') == 'danceLeft' then
			objectPlayAnimation(dancer, 'danceRight', true)
		else
			objectPlayAnimation(dancer, 'danceLeft', true)
		end
	end
end

function onUpdate(elapsed)
	timer = timer + elapsed
	setProperty('mist1.y', 100 + math.sin(timer) * 200)
	setProperty('mist2.y', 0 + math.sin(timer * 0.8) * 100)
	setProperty('mist3.y', -20 + math.sin(timer * 0.5) * 200)
	setProperty('mist4.y', -180 + math.sin(timer * 0.4) * 300)
	setProperty('mist5.y', -450 + math.sin(timer * 0.2) * 150)

	if doCarHaptics then
		runHaxeCode([[fun﻿kin.util.HapticUtil.vibrate(0, 0.05, 0.25, 0);]])
	end
end

----------------------------------------------------------------
-- SONG RESTART & PAUSE CONTROL
----------------------------------------------------------------
function onSongStart()
	resetFastCar()
	shootingStarBeat = 0
	shootingStarOffset = 2
end

function onCountdownStarted()
	resetFastCar()
end

function onPause() doCarHaptics = false end
function onResume() doCarHaptics = true end
