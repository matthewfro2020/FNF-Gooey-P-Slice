package mikolka.stages.cutscenes;

import openfl.filters.ShaderFilter;
import shaders.DropShadowScreenspace;
import mikolka.stages.erect.TankErect;
#if !LEGACY_PSYCH
import cutscenes.CutsceneHandler;
#end

class GooeyTankman {
	public function new(stage:TankErect) {
		this.stage = stage;
	}

	var gooeyCutSound:FlxSound = null;
	var tankmanCutscene:FlxAtlasSprite;
	var gooeyrimlightCamera:FlxCamera;
	var screenspaceGooeyRimlight:DropShadowScreenspace = new DropShadowScreenspace();

	var cutsceneSkipped:Bool = false;
	var canSkipCutscene:Bool = false;

	var isMobilePauseButtonPressed:Bool = false;

	public function new(x:Float, y:Float) {
		super(x, y, Paths.loadAnimateAtlas("erect/cutscene/StressCutTankGooey", "week7"), {
			FrameRate: 24.0,
			Reversed: false,
			// ?OnComplete:Void -> Void,
			ShowPivot: false,
			Antialiasing: true,
			ScrollFactor: new FlxPoint(1, 1),
		});
	}

	function preloadCutscene() {
		gooeyCutSound = FlxSound.load(Paths.sound('stressGooeyCutscene/lines/1'), 1.0, false);
		gooeyCutSound.volume = 1;

		PlayState.instance.girlfriend().playAnimation('tankFrozen', true, true);
		event.cancel(); // CANCEL THE COUNTDOWN!

		var skipText:FlxText = new FlxText(936, 618, 0, 'Skip [ ' + PlayState.instance.controls.getDialogueNameFromToken("CUTSCENE_ADVANCE", true) + ' ]', 20);
		skipText.setFormat(Paths.font('vcr.ttf'), 40, 0xFFFFFFFF, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
		skipText.scrollFactor.set();
		skipText.borderSize = 2;
		skipText.alpha = 0;
		PlayState.instance.currentStage.add(skipText);

		skipText.cameras = [PlayState.instance.camCutscene];

		tankmanGooeyCutscene = FlxAtlasSprite.init('TankmanGooeyStress', 0, 0);
		tankmanGooeyCutscene.setPosition(PlayState.instance.currentStage.getDad().x + 200, PlayState.instance.currentStage.getDad().y + 230);
		PlayState.instance.currentStage.add(tankmanGooeyCutscene);
		tankmanGooeyCutscene.zIndex = 101;

		gooeyrimlightCamera = new FlxCamera();
		FlxG.cameras.insert(gooeyrimlightCamera, (FlxG.onMobile) ? -4 : -2, false);
		gooeyrimlightCamera.bgColor = 0x00FFFFFF; // Show the game scene behind the camera.

		screenspaceGooeyRimlight.baseBrightness = -46;
		screenspaceGooeyRimlight.baseHue = -38;
		screenspaceGooeyRimlight.baseContrast = -25;
		screenspaceGooeyRimlight.baseSaturation = -20;
		var gooStartFilter:ShaderFilter = new ShaderFilter(screenspaceGooeyRimlight);

		gooeyrimlightCamera.filters = [gooStartFilter];

		tankmanGooeyCutscene.cameras = [gooeyrimlightCamera];

		var fakeFlora:FlxSprite = new FlxSprite(0, 0).loadSparrow('characters/flora/floraStressCutscene');
		fakeFlora.animation.addByPrefix('idle', 'idle', 24, true);
		fakeFlora.animation.addByPrefix('uhoh', 'uhoh', 12, false);
		fakeFlora.animation.addByPrefix('huh', 'huh', 12, false);
		fakeFlora.animation.addByPrefix('bye', 'bye', 24, false);
		fakeFlora.animation.play('idle');
		PlayState.instance.currentStage.add(fakeFlora);
		fakeFlora.setPosition(PlayState.instance.currentStage.getGirlfriend().x + 569, PlayState.instance.currentStage.getGirlfriend().y + 374);
		fakeFlora.zIndex = 199;

		var floraEyes:FlxSprite = new FlxSprite(0, 0).loadSparrow('characters/flora/floraStressCutsceneEyes');
		floraEyes.animation.addByPrefix('idle', 'idle', 24, true);
		floraEyes.animation.addByPrefix('uhoh', 'uhoh', 12, false);
		floraEyes.animation.addByPrefix('huh', 'huh', 12, false);
		floraEyes.animation.addByPrefix('bye', 'bye', 24, false);
		floraEyes.animation.play('idle');
		PlayState.instance.currentStage.add(floraEyes);
		floraEyes.setPosition(PlayState.instance.currentStage.getGirlfriend().x + 569, PlayState.instance.currentStage.getGirlfriend().y + 374);
		floraEyes.zIndex = 200;
		floraEyes.blend = 0;

		var tankBopLeft:FlxSprite = new FlxSprite(PlayState.instance.currentStage.getGirlfriend().x - 10,
			PlayState.instance.currentStage.getGirlfriend().y + 30).loadSparrow('characters/flora/LeftTanker');
		tankBopLeft.animation.addByPrefix('idle', 'idle', 24, true);
		tankBopLeft.animation.addByPrefix('aim', 'aim', 24, false);
		tankBopLeft.animation.addByPrefix('fuck', 'fuck', 12, false);
		tankBopLeft.animation.addByPrefix('goodbye', 'goodbye', 12, false);
		tankBopLeft.animation.play('idle');
		PlayState.instance.currentStage.add(tankBopLeft);
		tankBopLeft.zIndex = PlayState.instance.currentStage.getGirlfriend().zIndex - 3;

		var tankBopRight:FlxSprite = new FlxSprite(PlayState.instance.currentStage.getGirlfriend().x - 10,
			PlayState.instance.currentStage.getGirlfriend().y + 30).loadSparrow('characters/flora/RightTanker');
		tankBopRight.animation.addByPrefix('idle', 'idle', 24, true);
		tankBopRight.animation.play('idle');
		tankBopRight.animation.addByPrefix('aim', 'aim', 24, false);
		tankBopRight.animation.addByPrefix('shit', 'shit', 12, false);
		tankBopRight.animation.addByPrefix('grab', 'grab', 12, false);
		tankBopRight.animation.addByPrefix('fuckingDead', 'fuckingDead', 12, false);
		tankBopRight.animation.addByPrefix('throw', 'throw', 12, false);
		tankBopRight.animation.addByPrefix('chokeLoop', 'chokeLoop', 12, true);
		tankBopRight.animation.addByPrefix('goodbye', 'goodbye', 12, false);
		PlayState.instance.currentStage.add(tankBopRight);
		tankBopRight.zIndex = PlayState.instance.currentStage.getGirlfriend().zIndex - 3;

		var rim = new DropShadowShader();
		rim.setAdjustColor(-46, -38, -25, -20);
		rim.color = 0xFFDFEF3C;
		fakeFlora.shader = rim;
		rim.angle = 90;
		rim.attachedSprite = fakeFlora;

		adjustColor = new AdjustColorShader();

		adjustColor.hue = -40;
		adjustColor.saturation = -20;
		adjustColor.brightness = -40;
		adjustColor.contrast = -25;

		tankBopLeft.shader = adjustColor;
		tankBopRight.shader = adjustColor;

		fakeFlora.animation.onFrameChange.add(function() {
			rim.updateFrameInfo(fakeFlora.frame);
		});

		PlayState.instance.isInCutscene = true;
		PlayState.instance.camHUD.alpha = 0;

		PlayState.instance.currentStage.getGirlfriend().visible = false;
		PlayState.instance.currentStage.getBoyfriend().playAnimation('fakeIdle', true);
		PlayState.instance.currentStage.getDad().visible = false;
	}

	function gooeyStressCutscene() {
		if (PlayState.instance.currentVariation == 'gooey')
			var gooeyPos:Array<Float> = [
				PlayState.instance.currentStage.getBoyfriend().cameraFocusPoint.x,
				PlayState.instance.currentStage.getBoyfriend().cameraFocusPoint.y
			];
		var kamPos:Array<Float> = [
			PlayState.instance.currentStage.getGirlfriend().cameraFocusPoint.x,
			PlayState.instance.currentStage.getGirlfriend().cameraFocusPoint.y
		];
		var tankmanPos:Array<Float> = [
			PlayState.instance.currentStage.getDad().cameraFocusPoint.x,
			PlayState.instance.currentStage.getDad().cameraFocusPoint.y
		];

		cutsceneTimerManager = new FlxTimerManager();
		PlayState.instance.camCutscene.fade(0xFF000000, 1, true, null, true);

		new FlxTimer(cutsceneTimerManager).start(0, _ -> {
			cutsceneMusic = FlxSound.load(Paths.music("cutscene/cutscene", "week7"), true);
			cutsceneMusic.volume = 1;
			cutsceneMusic.play(false);

			PlayState.instance.tweenCameraToPosition(tankmanPos[0] + 0, tankmanPos[1] - 0, 2, FlxEase.smoothStepInOut);
			tankmanGooeyCutscene.scriptCall('doAnim');
		});
		new FlxTimer(cutsceneTimerManager).start(6.5 / 24, _ -> {
			gooeyCutSound.play(false);
		});
		new FlxTimer(cutsceneTimerManager).start(60 / 24, _ -> {
			gooeyCutSound = FlxSound.load(Paths.sound('stressGooeyCutscene/lines/2'), 1.0, false);
			gooeyCutSound.volume = 1;
			gooeyCutSound.play(false);
		});
		new FlxTimer(cutsceneTimerManager).start(93 / 24, _ -> {
			PlayState.instance.tweenCameraZoom(0.71, 1, true, FlxEase.expoOut);
		});
		new FlxTimer(cutsceneTimerManager).start(135 / 24, _ -> {
			PlayState.instance.tweenCameraZoom(0.7, 5, true, FlxEase.expoOut);
		});
		new FlxTimer(cutsceneTimerManager).start(269 / 24, _ -> {
			PlayState.instance.tweenCameraZoom(0.71, 1, true, FlxEase.expoOut);
		});
		new FlxTimer(cutsceneTimerManager).start(301 / 24, _ -> {
			PlayState.instance.tweenCameraZoom(0.72, 1, true, FlxEase.expoOut);
		});
		new FlxTimer(cutsceneTimerManager).start(311 / 24, _ -> {
			PlayState.instance.tweenCameraToPosition(kamPos[0] + 120, kamPos[1] + 200, 1.5, FlxEase.expoOut);
			PlayState.instance.tweenCameraZoom(0.9, 2.6, true, FlxEase.smoothStepInOut);
		});
		new FlxTimer(cutsceneTimerManager).start(332 / 24, _ -> {
			tankBopLeft.animation.play('aim');
			tankBopRight.animation.play('aim');
			fakeFlora.setPosition(PlayState.instance.currentStage.getGirlfriend().x - 13, PlayState.instance.currentStage.getGirlfriend().y + 41);
			floraEyes.setPosition(PlayState.instance.currentStage.getGirlfriend().x - 13, PlayState.instance.currentStage.getGirlfriend().y + 41);
			floraEyes.animation.play('uhoh');
			fakeFlora.animation.play('uhoh');
			PlayState.instance.currentStage.getBoyfriend().playAnimation('ruhRohRaggy', true);
			PlayState.instance.currentStage.getBoyfriend().visible = true;
			gooeyCutSound = FlxSound.load(Paths.sound('stressGooeyCutscene/gockCockStress'), 1.0, false);
			gooeyCutSound.volume = 1;
			gooeyCutSound.play(false);
		});
		new FlxTimer(cutsceneTimerManager).start(350 / 24, _ -> {
			PlayState.instance.currentStage.getBoyfriend().playAnimation('crystalGlow', true);
		});
		new FlxTimer(cutsceneTimerManager).start(352 / 24, _ -> {
			floraEyes.animation.play('huh');
			fakeFlora.animation.play('huh');
		});
		new FlxTimer(cutsceneTimerManager).start(368 / 24, _ -> {
			floraEyes.animation.play('bye');
			fakeFlora.animation.play('bye');
		});
		new FlxTimer(cutsceneTimerManager).start(371 / 24, _ -> {
			PlayState.instance.tweenCameraZoom(0.8, 0.5, true, FlxEase.expoOut);
			PlayState.instance.tweenCameraToPosition(kamPos[0] + 80, kamPos[1] + 120, 1, FlxEase.expoOut);
			PlayState.instance.currentStage.getGirlfriend().playAnimation('kamMurder', true);
			tankBopLeft.animation.play('fuck');
			tankBopRight.animation.play('shit');
			PlayState.instance.currentStage.getGirlfriend().visible = true;
			PlayState.instance.currentStage.getBoyfriend().playAnimation('omgFriend', true);
		});
		new FlxTimer(cutsceneTimerManager).start(372 / 24, _ -> {
			gooeyCutSound = FlxSound.load(Paths.sound('stressGooeyCutscene/kamMurder'), 1.0, false);
			gooeyCutSound.volume = 1;
			gooeyCutSound.play(false);
		});
		new FlxTimer(cutsceneTimerManager).start(391 / 24, _ -> {
			PlayState.instance.currentStage.getGirlfriend().playAnimation('grab', true);
			tankBopRight.animation.play('grab');
		});
		new FlxTimer(cutsceneTimerManager).start(401 / 24, _ -> {
			tankBopRight.animation.play('chokeLoop');
			tankBopLeft.animation.play('goodbye');
		});
		new FlxTimer(cutsceneTimerManager).start(431 / 24, _ -> {
			tankBopRight.animation.play('fuckingDead');
		});
		new FlxTimer(cutsceneTimerManager).start(446 / 24, _ -> {
			PlayState.instance.currentStage.getGirlfriend().playAnimation('helmetGrab', true);
			PlayState.instance.tweenCameraZoom(0.75, 0.5, true, FlxEase.expoOut);
			PlayState.instance.tweenCameraToPosition(kamPos[0] + 200, kamPos[1] + 200, 1, FlxEase.expoOut);
		});
		new FlxTimer(cutsceneTimerManager).start(456 / 24, _ -> {
			PlayState.instance.currentStage.getGirlfriend().playAnimation('iDontKnow', true);
			tankBopRight.animation.play('throw');
		});
		new FlxTimer(cutsceneTimerManager).start(460 / 24, _ -> {
			PlayState.instance.tweenCameraToPosition(kamPos[0] + 375, kamPos[1] + 275, 1, FlxEase.expoOut);
			PlayState.instance.tweenCameraZoom(0.9, 0.5, true, FlxEase.expoOut);
		});
		new FlxTimer(cutsceneTimerManager).start(461 / 24, _ -> {
			PlayState.instance.currentStage.getBoyfriend().playAnimation('chickenJockey', true);
		});
		new FlxTimer(cutsceneTimerManager).start(480 / 24, _ -> {
			PlayState.instance.tweenCameraToPosition(tankmanPos[0], tankmanPos[1], 3, FlxEase.smoothStepInOut);
			PlayState.instance.tweenCameraZoom(0.8, 3, true, FlxEase.expoOut);
			gooeyCutSound = FlxSound.load(Paths.sound('stressGooeyCutscene/lines/3'), 1.0, false);
			gooeyCutSound.volume = 1;
			gooeyCutSound.play(false);
			tankBopRight.animation.play('goodbye');
		});
		new FlxTimer(cutsceneTimerManager).start(495 / 24, _ -> {
			PlayState.instance.currentStage.getBoyfriend().playAnimation('2fakeIdle', true);
			PlayState.instance.currentStage.getGirlfriend().playAnimation('fakeIdle', true);
		});

		new FlxTimer(cutsceneTimerManager).start(545 / 24, _ -> {
			gooeyCutSound = FlxSound.load(Paths.sound('stressGooeyCutscene/lines/4'), 1.0, false);
			gooeyCutSound.volume = 1;
			gooeyCutSound.play(false);
		});
		new FlxTimer(cutsceneTimerManager).start(580 / 24, _ -> {
			PlayState.instance.tweenCameraZoom(0.81, 1, true, FlxEase.expoOut);
		});

		new FlxTimer(cutsceneTimerManager).start(607 / 24, _ -> {
			PlayState.instance.tweenCameraZoom(0.83, 1, true, FlxEase.expoOut);
		});

		new FlxTimer(cutsceneTimerManager).start(611 / 24, _ -> {
			PlayState.instance.tweenCameraToPosition(tankmanPos[0] + 0, tankmanPos[1] - 0, 2, FlxEase.smoothStepInOut);
			PlayState.instance.tweenCameraZoom(0.7, 1, true, FlxEase.smoothStepInOut);
		});

		new FlxTimer(cutsceneTimerManager).start(635 / 24, _ -> {
			canSkipCutscene = false;
			hasPlayedCutscene = true;
			cutsceneSkipped = true;
			PlayState.instance.isInCutscene = false;
			FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, 1);
			PlayState.instance.currentStage.getDad().visible = true;
			cutsceneMusic.stop();
			tankmanGooeyCutscene.destroy();

			skipText.visible = false;
			tankBopLeft.destroy();
			tankBopRight.destroy();
			fakeFlora.destroy();
			floraEyes.destroy();
			PlayState.instance.currentStage.getGirlfriend().playAnimation('idle', true);
			PlayState.instance.currentStage.getDad().playAnimation('idle', true);
			PlayState.instance.currentStage.getBoyfriend().playAnimation('idle', true);

			PlayState.instance.startCountdown();
			new FlxTimer().start(1, _ -> {
				FlxG.cameras.remove(gooeyrimlightCamera);
				gooeyrimlightCamera.destroy();
			});
		});
	}

	function skipCutscene() {
		if (PlayState.instance.currentVariation == 'gooey')
			cutsceneSkipped = true;
		hasPlayedCutscene = true;
		PlayState.instance.camCutscene.fade(0xFF000000, 0.5, false, null, true);
		cutsceneMusic.fadeOut(0.5, 0);
		if (gooeyCutSound != null) {
			gooeyCutSound.fadeOut(0.5, 0);
		}

		new FlxTimer().start(0.5, _ -> {
			tankmanGooeyCutscene.destroy();
			PlayState.instance.justUnpaused = true;
			PlayState.instance.camCutscene.fade(0xFF000000, 0.5, true, null, true);

			cutsceneTimerManager.clear();
			cutsceneMusic.stop();
			if (gooeyCutSound != null) {
				gooeyCutSound.stop();
			}

			PlayState.instance.startCountdown();
			skipText.visible = false;

			tankBopLeft.destroy();
			tankBopRight.destroy();
			fakeFlora.destroy();
			floraEyes.destroy();
			FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, 1);

			PlayState.instance.currentStage.getGirlfriend().visible = true;
			PlayState.instance.currentStage.getBoyfriend().visible = true;
			PlayState.instance.currentStage.getDad().visible = true;

			PlayState.instance.currentStage.getGirlfriend().playAnimation('idle', true);
			PlayState.instance.currentStage.getDad().playAnimation('idle', true);
			PlayState.instance.currentStage.getBoyfriend().playAnimation('idle', true);
		});
		new FlxTimer().start(1, _ -> {
			FlxG.cameras.remove(gooeyrimlightCamera);
			gooeyrimlightCamera.destroy();
		});
	}

	function kill():Void {
		cleanupTankmanGroup();
	}

	function cleanupTankmanGroup():Void {
		if (tankmanGroup != null) {
			PlayState.instance.currentStage.remove(tankmanGroup);
			tankmanGroup.destroy();
			tankmanGroup = null;
		}
	}
}
