package mikolka.stages.erect;

import mikolka.vslice.StickerSubState;
import mikolka.stages.objects.TankmenBG;
#if !LEGACY_PSYCH
import cutscenes.CutsceneHandler;
import objects.Character;
import substates.GameOverSubstate;
#end
import mikolka.stages.cutscenes.VideoCutscene;
import mikolka.stages.cutscenes.PicoTankman;
import openfl.filters.ShaderFilter;
import shaders.DropShadowScreenspace;
import mikolka.stages.scripts.PicoCapableStage;
import mikolka.compatibility.VsliceOptions;
import shaders.DropShadowShader;
import flixel.FlxCamera;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

class TankErect extends BaseStage {
	var sniper:FlxSprite;
	var guy:FlxSprite;
	var tankmanRim:DropShadowShader;
	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var cutscene:PicoTankman;
	var pico_stage:PicoCapableStage;
	private var gooeyCutSound:FlxSound;
	private var tankmanGooeyCutscene:FlxSprite;
	private var gooeyrimlightCamera:FlxCamera;
	private var screenspaceGooeyRimlight:DropShadowScreenspace;

	private var cutsceneSkipped:Bool = false;
	private var canSkipCutscene:Bool = false;
	private var hasPlayedCutscene:Bool = false;

	private var isMobilePauseButtonPressed:Bool = false;

	private var cutsceneMusic:FlxSound;
	private var cutsceneTimerManager:FlxTimerManager;

	private var skipText:FlxText;
	private var tankBopLeft:FlxSprite;
	private var tankBopRight:FlxSprite;
	private var fakeFlora:FlxSprite;
	private var floraEyes:FlxSprite;

	public function startGooeyTankmanCutscene() {
		if (songName == "stress-(gooey-mix)") {
			preloadCutscene();
			gooeyStressCutscene();
		}
	}

	private function preloadCutscene() {
		// Use FlxSound constructor instead of loadSound
		gooeyCutSound = new FlxSound().loadEmbedded(Paths.sound('stressGooeyCutscene/lines/1'), false, false);
		gooeyCutSound.volume = 1;

		// Replace with a more generic character method
		game.getGF().playAnim('tankFrozen', true, true);

		// Modify skip text creation
		skipText = new FlxText(936, 618, 0, 'Skip [ ENTER ]', 20);
		skipText.setFormat(Paths.font('vcr.ttf'), 40, 0xFFFFFFFF, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
		skipText.scrollFactor.set();
		skipText.borderSize = 2;
		skipText.alpha = 0;

		// Use a more generic method to add text to the stage
		if (game.stage != null) {
			game.stage.add(skipText);
		}

		// Use game.camHUD instead of direct camera access
		skipText.cameras = [game.camHUD];
	}

	private function gooeyStressCutscene() {
		// Check variation using game method
		if (game.stageData.variation != 'gooey')
			return;

		// Use game methods for camera focus points
		var gooeyPos:Array<Float> = [
			game.boyfriendGroup.members[0].cameraPosition[0],
			game.boyfriendGroup.members[0].cameraPosition[1]
		];

		var kamPos:Array<Float> = [
			game.girlfriendGroup.members[0].cameraPosition[0],
			game.girlfriendGroup.members[0].cameraPosition[1]
		];

		var tankmanPos:Array<Float> = [
			game.dadGroup.members[0].cameraPosition[0],
			game.dadGroup.members[0].cameraPosition[1]
		];

		cutsceneTimerManager = new FlxTimerManager();
		game.camHUD.fade(0xFF000000, 1, true);
	}

	private function skipCutscene() {
		// Check variation using game method
		if (game.stageData.variation != 'gooey')
			return;

		cutsceneSkipped = true;
		hasPlayedCutscene = true;

		game.camHUD.fade(0xFF000000, 0.5, false);
		cutsceneMusic.fadeOut(0.5, 0);

		if (gooeyCutSound != null) {
			gooeyCutSound.fadeOut(0.5, 0);
		}

		new FlxTimer().start(0.5, function(_) {
			tankmanGooeyCutscene.destroy();
			game.paused = false;
			game.camHUD.fade(0xFF000000, 0.5, true);

			cutsceneTimerManager.clear();
			cutsceneMusic.stop();

			if (gooeyCutSound != null) {
				gooeyCutSound.stop();
			}

			game.startCountdown();
			skipText.visible = false;

			// Safely destroy sprites
			destroyOptionalSprites([tankBopLeft, tankBopRight, fakeFlora, floraEyes]);

			FlxTween.tween(game.camHUD, {alpha: 1}, 1);

			// Use group methods for visibility and animations
			for (gf in game.girlfriendGroup.members) {
				gf.visible = true;
				gf.playAnim('idle', true);
			}

			for (bf in game.boyfriendGroup.members) {
				bf.visible = true;
				bf.playAnim('idle', true);
			}

			for (dad in game.dadGroup.members) {
				dad.visible = true;
				dad.playAnim('idle', true);
			}
		});

		new FlxTimer().start(1, function(_) {
			FlxG.cameras.remove(gooeyrimlightCamera);
			gooeyrimlightCamera.destroy();
		});
	}

	// Utility method to safely destroy optional sprites
	private function destroyOptionalSprites(sprites:Array<FlxSprite>) {
		for (sprite in sprites) {
			if (sprite != null)
				sprite.destroy();
		}
	}

	override function kill():Void {
		cleanupTankmanGroup();
	}

	private function cleanupTankmanGroup():Void {
		if (game.stage != null && tankmanRun != null) {
			game.stage.remove(tankmanRun);
			tankmanRun.destroy();
			tankmanRun = null;
		}
	}

	public function new() {
		if (songName == "stress-(pico-mix)")
			pico_stage = new PicoCapableStage(true);
		super();
	}

	// Remaining methods like create(), beatHit(), eventCalled(), createPost(),
	// applyAbotShader(), and applyShader() remain the same as in the original code.
	// You would copy those methods from the original file.
	// Example of a few existing methods
	override function create() {
		super.create();

		var bg:BGSprite = new BGSprite('erect/bg', -985, -805, 1, 1);
		bg.scale.set(1.15, 1.15);
		add(bg);

		// Rest of the create method remains the same
	}

	override function beatHit() {
		super.beatHit();
		if (curBeat % 2 == 0) {
			sniper.animation.play('idle', true);
			guy.animation.play('idle', true);
		}
		if (FlxG.random.bool(2))
			sniper.animation.play('sip', true);
	}
}
