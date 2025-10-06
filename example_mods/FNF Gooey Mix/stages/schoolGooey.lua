--------------------------------------------------------------
-- School (Gooey) - Psych Engine Lua v1.0.4+
-- Includes all pixel props, freak behavior, and Gooey shaders
--------------------------------------------------------------

function onCreate()
	setProperty('defaultCamZoom', 1)

	-- === BACKGROUND LAYERS ===
	makeLuaSprite('sky', 'weeb/erect/weebSky', -626, -78)
	setScrollFactor('sky', 0.2, 0.2)
	scaleObject('sky', 6, 6)
	setObjectOrder('sky', 10)
	addLuaSprite('sky', false)

	makeLuaSprite('backTrees', 'weeb/erect/weebBackTrees', -842, -80)
	setScrollFactor('backTrees', 0.5, 0.5)
	scaleObject('backTrees', 6, 6)
	setObjectOrder('backTrees', 15)
	addLuaSprite('backTrees', false)

	makeLuaSprite('school', 'weeb/erect/weebSchool', -816, -38)
	setScrollFactor('school', 0.75, 0.75)
	scaleObject('school', 6, 6)
	setObjectOrder('school', 20)
	addLuaSprite('school', false)

	makeAnimatedLuaSprite('treesBG', 'weeb/erect/weebTrees', -806, -1050)
	addAnimationByIndices('treesBG', 'treeLoop', 'treeLoop', {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}, 12)
	objectPlayAnimation('treesBG', 'treeLoop', true)
	setScrollFactor('treesBG', 1, 1)
	scaleObject('treesBG', 6, 6)
	setObjectOrder('treesBG', 60)
	addLuaSprite('treesBG', false)

	makeLuaSprite('street', 'weeb/erect/weebStreet', -662, 6)
	setScrollFactor('street', 1, 1)
	scaleObject('street', 6, 6)
	setObjectOrder('street', 30)
	addLuaSprite('street', false)

	makeLuaSprite('treesFG', 'weeb/erect/weebTreesBack', -500, 6)
	setScrollFactor('treesFG', 1, 1)
	scaleObject('treesFG', 6, 6)
	setObjectOrder('treesFG', 40)
	addLuaSprite('treesFG', false)

	makeAnimatedLuaSprite('petals', 'weeb/erect/petals', -20, -40)
	addAnimationByPrefix('petals', 'leaves', 'PETALS ALL', 24, true)
	objectPlayAnimation('petals', 'leaves', true)
	setScrollFactor('petals', 0.85, 0.85)
	scaleObject('petals', 6, 6)
	setObjectOrder('petals', 70)
	addLuaSprite('petals', true)

	makeAnimatedLuaSprite('freaks', 'weeb/bgFreaks', -100, 190)
	addAnimationByIndices('freaks', 'danceLeft', 'BG girls group', {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14}, 24)
	addAnimationByIndices('freaks', 'danceRight', 'BG girls group', {15,16,17,18,19,20,21,22,23,24,25,26,27,28,29}, 24)
	addAnimationByIndices('freaks', 'danceLeft-scared', 'BG fangirls dissuaded', {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14}, 24)
	addAnimationByIndices('freaks', 'danceRight-scared', 'BG fangirls dissuaded', {15,16,17,18,19,20,21,22,23,24,25,26,27,28,29}, 24)
	objectPlayAnimation('freaks', 'danceLeft', true)
	setScrollFactor('freaks', 0.9, 0.9)
	scaleObject('freaks', 6, 6)
	setProperty('freaks.alpha', 1)
	setObjectOrder('freaks', 100)
	addLuaSprite('freaks', true)
end

--------------------------------------------------------------
-- Song-based behavior (Roses freaks toggle)
--------------------------------------------------------------
function onCreatePost()
	local songName = string.lower(songName or getPropertyFromClass('PlayState', 'SONG.song'))
	if songName == 'roses' then
		setProperty('freaks.idleSuffix', '-scared')
	else
		setProperty('freaks.idleSuffix', '')
	end
end

--------------------------------------------------------------
-- Gooey Shader Logic
--------------------------------------------------------------
function onSpawnNote()
	runHaxeCode([[
		if (FlxG.save.data.gooeyShaders != false)
		{
			var applyShader = function(character:Dynamic, type:String)
			{
				var rim = new funkin.graphics.shaders.DropShadowShader();
				rim.setAdjustColor(-66, -10, 24, -23);
				rim.color = 0xFF52351d;
				rim.antialiasAmt = 0;
				rim.distance = 5;

				switch(type)
				{
					case "BF":
						rim.angle = 90;
						character.shader = rim;
						rim.loadAltMask('assets/week6/images/weeb/erect/masks/bfPixel_mask.png');
						rim.maskThreshold = 1;
						rim.useAltMask = false;

						character.animation.callback = function()
						{
							if (PlayState.instance.currentStage.getBoyfriend() != null)
								rim.updateFrameInfo(PlayState.instance.currentStage.getBoyfriend().frame);
						};

					case "GF":
						rim.setAdjustColor(-42, -10, 5, -25);
						rim.angle = 90;
						character.shader = rim;
						rim.distance = 3;
						rim.threshold = 0.3;
						rim.loadAltMask('assets/week6/images/weeb/erect/masks/gfPixel_mask.png');
						rim.maskThreshold = 1;
						rim.useAltMask = false;

						character.animation.callback = function()
						{
							rim.updateFrameInfo(PlayState.instance.currentStage.getGirlfriend().frame);
						};

					case "DAD":
						rim.angle = 90;
						character.shader = rim;
						rim.loadAltMask('assets/week6/images/weeb/erect/masks/senpai_mask.png');
						rim.maskThreshold = 1;
						rim.useAltMask = true;

						character.animation.callback = function()
						{
							rim.updateFrameInfo(PlayState.instance.currentStage.getDad().frame);
						};
				}
			};

			applyShader(PlayState.instance.currentStage.getBoyfriend(), "BF");
			applyShader(PlayState.instance.currentStage.getGirlfriend(), "GF");
			applyShader(PlayState.instance.currentStage.getDad(), "DAD");
		}
	]])
end

--------------------------------------------------------------
-- Freak dance behavior
--------------------------------------------------------------
function onBeatHit()
	if curBeat % 2 == 0 then
		objectPlayAnimation('freaks', 'danceLeft' .. getProperty('freaks.idleSuffix'), true)
	else
		objectPlayAnimation('freaks', 'danceRight' .. getProperty('freaks.idleSuffix'), true)
	end
end
