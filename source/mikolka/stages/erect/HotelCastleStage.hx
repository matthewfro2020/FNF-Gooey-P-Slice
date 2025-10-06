package states.stages;

import states.stages.objects.*;

class HotelCastleStage extends BaseStage {
	// If you're moving your stage from PlayState to a stage file,
	// you might have to rename some variables if they're missing, for example: camZooming -> game.camZooming
	override function create() {
		var backWall = new BGSprite(-1000, -1000);
		backWall.loadGraphic("gooeyMix/week60037/hotelCastle/backWall");
		backWall.scrollFactor.set(1.1, 1.1);
		add(backWall);

		var stageWall = new BGSprite(360, -400);
		stageWall.loadGraphic("gooeyMix/week60037/hotelCastle/projWall", true, 0, 0, true);
		stageWall.animation.addByPrefix("morpho", "morpho", 12, true);
		stageWall.scrollFactor.set(0.9, 0.9);
		stageWall.animation.play("morpho", true);
		add(stageWall);

		var backFrame = new BGSprite(870, -150);
		backFrame.loadGraphic("gooeyMix/week60037/hotelCastle/backFrame");
		backFrame.scrollFactor.set(0.95, 0.95);
		add(backFrame);

		var wires = new BGSprite(570, -250);
		wires.loadGraphic("gooeyMix/week60037/hotelCastle/wires");
		wires.scrollFactor.set(0.975, 0.975);
		add(wires);

		var topLantern1 = new BGSprite(800, -100);
		topLantern1.loadGraphic("gooeyMix/week60037/hotelCastle/hangingLantern");
		topLantern1.scrollFactor.set(0.975, 0.975);
		add(topLantern1);

		var topLantern2 = new BGSprite(2240, -100);
		topLantern2.loadGraphic("gooeyMix/week60037/hotelCastle/hangingLantern");
		topLantern2.scrollFactor.set(0.975, 0.975);
		add(topLantern2);

		var morphoStage = new BGSprite(549, 727);
		morphoStage.loadGraphic("gooeyMix/week60037/hotelCastle/morphoStage");
		add(morphoStage);

		var candleBack = new BGSprite(2160, 720);
		candleBack.loadGraphic("gooeyMix/week60037/hotelCastle/candle");
		candleBack.set_flipX(true);
		add(candleBack);

		var candleBackLight = new BGSprite(2120, 720);
		candleBackLight.loadGraphic("gooeyMix/week60037/hotelCastle/candleFlame", true, 0, 0, true);
		candleBackLight.animation.addByPrefix("flame", "flame", 12, true);
		candleBackLight.set_flipX(true);
		candleBackLight.animation.play("flame", true);
		add(candleBackLight);

		var bottomLantern1 = new BGSprite(575, 770);
		bottomLantern1.loadGraphic("gooeyMix/week60037/hotelCastle/lantern");
		add(bottomLantern1);

		var bottomLantern2 = new BGSprite(2450, 750);
		bottomLantern2.loadGraphic("gooeyMix/week60037/hotelCastle/lantern");
		add(bottomLantern2);

		var boppers = new BGSprite(-1000, -1000);
		boppers.loadGraphic("gooeyMix/week60037/hotelCastle/ASMPbop1", true, 0, 0, true);
		boppers.animation.addByPrefix("idle", "idleBop", 12, true);
		boppers.animation.play("idle", true);
		add(boppers);

		var candleFront = new BGSprite(860, 940);
		candleFront.loadGraphic("gooeyMix/week60037/hotelCastle/candle");
		add(candleFront);

		// LIGHT / FOREGROUND FX
		var spotlight1 = new BGSprite(-1000, -1000);
		spotlight1.loadGraphic("gooeyMix/week60037/hotelCastle/spotlight1");
		add(spotlight1);

		var spotlight2 = new BGSprite(-1000, -1000);
		spotlight2.loadGraphic("gooeyMix/week60037/hotelCastle/spotlight2");
		add(spotlight2);

		var bottomLantern1Light = new BGSprite(390, 620);
		bottomLantern1Light.loadGraphic("gooeyMix/week60037/hotelCastle/lanternLight");
		bottomLantern1Light.scrollFactor.set(0.975, 0.975);
		add(bottomLantern1Light);

		var bottomLantern2Light = new BGSprite(2280, 600);
		bottomLantern2Light.loadGraphic("gooeyMix/week60037/hotelCastle/lanternLight");
		bottomLantern2Light.scrollFactor.set(0.975, 0.975);
		add(bottomLantern2Light);

		var topLantern1Light = new BGSprite(625, 120);
		topLantern1Light.loadGraphic("gooeyMix/week60037/hotelCastle/lanternLight");
		topLantern1Light.scrollFactor.set(0.975, 0.975);
		add(topLantern1Light);

		var topLantern2Light = new BGSprite(2070, 120);
		topLantern2Light.loadGraphic("gooeyMix/week60037/hotelCastle/lanternLight");
		topLantern2Light.scrollFactor.set(0.975, 0.975);
		add(topLantern2Light);

		var candleFrontLight = new BGSprite(860, 940);
		candleFrontLight.loadGraphic("gooeyMix/week60037/hotelCastle/candleFlame", true, 0, 0, true);
		candleFrontLight.animation.addByPrefix("flame", "flame", 12, true);
		candleFrontLight.animation.play("flame", true);
		add(candleFrontLight);
	}

	override function createPost() {
		var rim = new shaders.DropShadowShader();
		rim.setAdjustColor(0, 0, 0, 0);
		rim.color = 0xFF423427;
		character.shader = rim;
		rim.attachedSprite = character;
		rim.threshold = -1;

		switch (charType) {
			case "bf":
				rim.angle = 67.5;
			case "gf":
				rim.angle = 90;
				rim.color = 0xFF000000;
			case "gooey":
				rim.angle = 67.5;
			default:
				{
					rim.angle = 90;
					rim.threshold = 0.1;
					sprite.shader = rim;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
		}
	}

	function preloadGooeyCut() {
		var skipText:FlxText = new FlxText(936, 618, 0, 'Skip [ ' + PlayState.instance.controls.getDialogueNameFromToken("CUTSCENE_ADVANCE", true) + ' ]', 20);
		skipText.setFormat(Paths.font('vcr.ttf'), 40, 0xFFFFFFFF, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
		skipText.scrollFactor.set();
		skipText.borderSize = 2;
		skipText.alpha = 0;
		add(skipText);

		// PlayState.instance.camGame.alpha = 0;
		PlayState.instance.camHUD.alpha = 0;
		PlayState.instance.dad().visible = false;

		var fakeGooey:BGSprite = new BGSprite(0, 0).loadSparrow('gooeyMix/week60037/hotelCastle/GooeyCut');
		fakeGooey.animation.addByPrefix('idle', 'balls', 12, false);
		fakeGooey.animation.addByPrefix('walk', 'walk', 12, false);
		fakeGooey.animation.addByPrefix('huh', 'huh', 12, false);
		fakeGooey.animation.addByPrefix('hmmm', 'hmmm', 12, false);
		fakeGooey.animation.addByPrefix('imSoSmart', 'imSoSmart', 12, false);
		fakeGooey.animation.addByPrefix('bye', 'bye', 24, false);
		fakeGooey.animation.addByPrefix('hi', 'hi', 12, false);
		fakeGooey.animation.play('idle');
		add(fakeGooey);
		fakeGooey.setPosition(-427, 727); // moved down by 200
		fakeGooey.zIndex = 111;
		fakeGooey.scrollFactor.set(1.1, 1.1);

		var bubble:BGSprite = new BGSprite(0, 0).loadSparrow('gooeyMix/week60037/hotelCastle/GooeyCutBubble');
		bubble.animation.addByPrefix('idle', 'buble', 6, true);
		bubble.animation.play('idle');
		add(bubble);
		bubble.scrollFactor.set(0, 0);
		bubble.setPosition(FlxG.width - bubble.width, FlxG.height - bubble.height);
		bubble.zIndex = 300;
		bubble.alpha = 0;
		bubble.flipX = true;
		bubble.scale.set(1.3, 1.3);

		var thoughts:BGSprite = new BGSprite(0, 0).loadSparrow('gooeyMix/week60037/hotelCastle/GooeyCutBubble');
		thoughts.animation.addByPrefix('idle', 'blank', 12, true);
		thoughts.animation.addByPrefix('solike', 'solike', 12, false);
		thoughts.animation.addByPrefix('imBrokeAF', 'imBrokeAF', 12, false);
		thoughts.animation.addByPrefix('butWhatIf', 'butWhatIf', 12, false);
		thoughts.animation.addByPrefix('iRobMyFriends', 'iRobMyFriends', 12, false);
		thoughts.animation.addByPrefix('andUseTheMoney', 'andUseTheMoney', 12, false);
		thoughts.animation.addByPrefix('toWin', 'toWin', 12, false);
		thoughts.animation.addByPrefix('andGetMOREmoney', 'andGetMOREmoney', 12, false);
		thoughts.animation.addByPrefix('imSoFuckingSmart', 'imSoFuckingSmart', 12, false);
		thoughts.animation.play('idle');
		add(thoughts);
		thoughts.scrollFactor.set(0, 0);
		thoughts.setPosition(FlxG.width - thoughts.width - 230, FlxG.height - thoughts.height + 200);
		thoughts.zIndex = 301;

		theBois = new BGSprite(0, 0).loadSparrow('gooeyMix/week60037/hotelCastle/KamAndMatt');
		theBois.animation.addByPrefix('idle', 'talkLoop', 3, true);
		theBois.animation.addByPrefix('yoink', 'yoink', 12, false);
		theBois.animation.play('idle');
		add(theBois);
		theBois.scrollFactor.set(0, 0);
		theBois.setPosition(FlxG.width - theBois.width, FlxG.height - theBois.height);
		theBois.zIndex = 302;
		theBois.alpha = 0;

		refresh();
		FlxG.camera.fade(0xFF000000, 1, true);
		var gooeyPos:Array<Float> = [
			getDad().cameraFocusPoint.x,
			getDad().cameraFocusPoint.y
		];
		PlayState.instance.tweenCameraZoom(1.1, 0.5, true, FlxEase.expoOut);
		PlayState.instance.tweenCameraToPosition(gooeyPos[0] - 700, gooeyPos[1] + 600, 3, FlxEase.expoOut);
	}

	function gooeyCut() {
		var gooeyPos:Array<Float> = [
			getDad().cameraFocusPoint.x,
			getDad().cameraFocusPoint.y
		];

		cutsceneTimerManager = new FlxTimerManager();

		new FlxTimer(cutsceneTimerManager).start(0.05, _ -> {
			fakeGooey.animation.play('walk');
		});

		new FlxTimer(cutsceneTimerManager).start(0.365, _ -> {
			cutsceneMusic = FunkinSound.load(Paths.music("cutscene/TheEpic"), true);
			cutsceneMusic.volume = 1;
			cutsceneMusic.play(false);

			gooeyCutSound = FunkinSound.load(Paths.sound('gooeyCutscene/GooeyCutSound1'), 1.0, false);
			gooeyCutSound.volume = 1;
			gooeyCutSound.play(false);
		});

		new FlxTimer(cutsceneTimerManager).start(3.5, _ -> {
			PlayState.instance.tweenCameraToPosition(gooeyPos[0] - 100, gooeyPos[1] + 300, 3, FlxEase.expoOut);
			PlayState.instance.tweenCameraZoom(0.6, 3, true, FlxEase.expoOut);
		});
		new FlxTimer(cutsceneTimerManager).start(5.5, _ -> {
			fakeGooey.animation.play('huh');
			PlayState.instance.tweenCameraToPosition(gooeyPos[0] - 1000, gooeyPos[1] + 500, 3, FlxEase.expoOut);
			PlayState.instance.tweenCameraZoom(0.9, 3, true, FlxEase.expoOut);

			gooeyCutSound = FunkinSound.load(Paths.sound('gooeyCutscene/GooeyCutSound2'), 1.0, false);
			gooeyCutSound.volume = 1;
			gooeyCutSound.play(false);
		});
		new FlxTimer(cutsceneTimerManager).start(7.5, _ -> {
			PlayState.instance.tweenCameraToPosition(gooeyPos[0] - 850, gooeyPos[1] + 600, 2, FlxEase.quadInOut);
			PlayState.instance.tweenCameraZoom(1, 2, true, FlxEase.quadInOut);
			fakeGooey.animation.play('hmmm');
			FlxTween.tween(bubble, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
			FlxTween.tween(bubble.scale, {x: 1, y: 1}, 2, {ease: FlxEase.quadInOut});
		});
		new FlxTimer(cutsceneTimerManager).start(9.5, _ -> {
			thoughts.animation.play('solike');
			gooeyCutSound = FunkinSound.load(Paths.sound('gooeyCutscene/GooeyCutSound3'), 1.0, false);
			gooeyCutSound.volume = 1;
			gooeyCutSound.play(false);
		});
		new FlxTimer(cutsceneTimerManager).start(10, _ -> {
			thoughts.animation.play('imBrokeAF');
		});
		new FlxTimer(cutsceneTimerManager).start(10.5, _ -> {
			thoughts.animation.play('butWhatIf');
		});
		new FlxTimer(cutsceneTimerManager).start(11, _ -> {
			thoughts.animation.play('iRobMyFriends');
		});
		new FlxTimer(cutsceneTimerManager).start(11.5, _ -> {
			thoughts.animation.play('andUseTheMoney');
		});
		new FlxTimer(cutsceneTimerManager).start(12, _ -> {
			thoughts.animation.play('toWin');
			fakeGooey.animation.play('imSoSmart');
		});
		new FlxTimer(cutsceneTimerManager).start(12.65, _ -> {
			thoughts.animation.play('andGetMOREmoney');
		});
		new FlxTimer(cutsceneTimerManager).start(13.5, _ -> {
			thoughts.animation.play('imSoFuckingSmart');
			FlxTween.tween(bubble, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
		});
		new FlxTimer(cutsceneTimerManager).start(14.5, _ -> {
			fakeGooey.animation.play('bye');
			theBois.alpha = 1;
			FlxTween.tween(theBois, {x: FlxG.width - theBois.width + 300}, 2, {ease: FlxEase.expoOut});
			FlxTween.tween(theBois, {y: FlxG.height - theBois.height + 300}, 2, {ease: FlxEase.expoOut});
			gooeyCutSound = FunkinSound.load(Paths.sound('gooeyCutscene/GooeyCutSound4'), 1.0, false);
			gooeyCutSound.volume = 1;
			gooeyCutSound.play(false);
		});
		new FlxTimer(cutsceneTimerManager).start(15.5, _ -> {
			theBois.animation.play('yoink');
		});
		new FlxTimer(cutsceneTimerManager).start(16.5, _ -> {
			fakeGooey.setPosition(-427, 527);
			fakeGooey.scrollFactor.set(1, 1);
			FlxTween.tween(theBois, {x: FlxG.width - theBois.width - 500}, 1, {ease: FlxEase.quadInOut});
			FlxTween.tween(theBois, {y: FlxG.height - theBois.height - 500}, 1, {ease: FlxEase.quadInOut});
		});
		new FlxTimer(cutsceneTimerManager).start(17, _ -> {
			fakeGooey.animation.play('hi');
			PlayState.instance.tweenCameraToPosition(gooeyPos[0], gooeyPos[1], 3, FlxEase.expoOut);
			PlayState.instance.tweenCameraZoom(0.7, 3, true, FlxEase.expoOut);
			theBois.alpha = 0;
			gooeyCutSound = FunkinSound.load(Paths.sound('gooeyCutscene/GooeyCutSound5'), 1.0, false);
			gooeyCutSound.volume = 1;
			gooeyCutSound.play(false);
		});

		new FlxTimer(cutsceneTimerManager).start(18.85, _ -> {
			gooeyShaderApply();
		});

		new FlxTimer(cutsceneTimerManager).start(19.5, _ -> {
			getDad().visible = true;
			fakeGooey.visible = false;
			getDad().playAnimation('hey', true);
			getBoyfriend().playAnimation('hey', true);
		});

		new FlxTimer(cutsceneTimerManager).start(20.5, _ -> {
			getDad().playAnimation('idle', true);
			getBoyfriend().playAnimation('idle', true);

			fakeGooey.destroy();
			theBois.destroy();
			thoughts.destroy();
			bubble.destroy();

			canSkipCutscene = false;
			hasPlayedCutscene = true;
			cutsceneSkipped = true;
			PlayState.instance.isInCutscene = false;
			skipText.visible = false;

			PlayState.instance.startCountdown();

			FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, 1);
		});
	}
}
