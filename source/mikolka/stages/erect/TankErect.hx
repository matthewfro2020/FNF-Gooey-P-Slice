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
		gf.animation.play('tankFrozen', true, true);

		// Modify skip text creation
		skipText = new FlxText(936, 618, 0, 'Skip [ ENTER ]', 20);
		skipText.setFormat(Paths.font('vcr.ttf'), 40, 0xFFFFFFFF, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
		skipText.scrollFactor.set();
		skipText.borderSize = 2;
		skipText.alpha = 0;

		// Use a more generic method to add text to the stage
		if (game.stages != null) {
			game.stages.add(skipText);
		}

		// Use game.camHUD instead of direct camera access
		skipText.cameras = [game.camHUD];
	}

	private function gooeyStressCutscene() {
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
			for (gf in game.gfGroup.members) {
				gf.visible = true;
				gf.animation.play('idle', true);
			}

			for (bf in game.boyfriendGroup.members) {
				bf.visible = true;
				bf.animation.play('idle', true);
			}

			for (dad in game.dadGroup.members) {
				dad.visible = true;
				dad.animation.play('idle', true);
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
		if (game.stages != null && tankmanRun != null) {
			game.stages.remove(tankmanRun);
			tankmanRun.destroy();
			tankmanRun = null;
		}
	}

	public function new() {
		if (songName == "stress-(pico-mix)") pico_stage = new PicoCapableStage(true);
		super();
	}
	override function create()
	{
		super.create();

		var bg:BGSprite = new BGSprite('erect/bg', -985, -805, 1, 1);
		bg.scale.set(1.15, 1.15);
		add(bg);

		sniper = new FlxSprite(-346, 245);
		sniper.frames = Paths.getSparrowAtlas('erect/sniper');
		sniper.animation.addByPrefix("idle", "Tankmanidlebaked instance 1", 24);
		sniper.animation.addByPrefix("sip", "tanksippingBaked instance 1", 24);
		sniper.scale.set(1.15, 1.15);
		add(sniper);

		guy = new FlxSprite(1175, 270);
		guy.frames = Paths.getSparrowAtlas('erect/guy');
		guy.animation.addByPrefix("idle", "BLTank2 instance 1", 24);
		guy.scale.set(1.15, 1.15);
		add(guy);

		tankmanRun = new FlxTypedGroup<TankmenBG>();
		add(tankmanRun);
		if (PicoCapableStage.instance != null)
			PicoCapableStage.instance.onABotInit.addOnce( (pico) ->{
			applyAbotShader(pico.abot.speaker);
			applyShader(pico.abot.bg,"");
		});
		if (songName == "stress-(pico-mix)")
		{
			pico_stage.create();
			game.stages.remove(pico_stage);
			game.stages.insert(1,pico_stage);
			StickerSubState.STICKER_SET = "stickers-set-2"; //? yep, it's pico time!
			this.cutscene = new PicoTankman(this);
			if(!seenCutscene) setStartCallback(VideoCutscene.playVideo.bind('stressPicoCutscene',startCountdown));
			setEndCallback(cutscene.playCutscene);
		}
		
	}

	override function beatHit()
	{
		super.beatHit();
		if (curBeat % 2 == 0)
		{
			sniper.animation.play('idle', true);
			guy.animation.play('idle', true);
		}
		if (FlxG.random.bool(2))
			sniper.animation.play('sip', true);
	}
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
		if(eventName == "Change Character" && VsliceOptions.SHADERS){
			switch(value1.toLowerCase().trim()) {
				case 'gf' | 'girlfriend' | '2':
					applyShader(gf, gf.curCharacter);
				case 'dad' | 'opponent' | '1':
					applyShader(dad, dad.curCharacter);
				default:
					applyShader(boyfriend, boyfriend.curCharacter);
			}
		}
	}

	override function createPost()
	{
		if (VsliceOptions.SHADERS)
		{
			applyShader(boyfriend, boyfriend.curCharacter);
			applyShader(gf, gf.curCharacter);
			applyShader(dad, dad.curCharacter);
			
		}
		if (!VsliceOptions.LOW_QUALITY)
		{
			var bricks:BGSprite = new BGSprite('erect/bricksGround', 375, 640, 1, 1);
			bricks.scale.set(1.15, 1.15);
			add(bricks);

			for (daGf in gfGroup)
			{
				var gf:Character = cast daGf;
				if (gf.curCharacter == 'otis-speaker')
				{
					GameOverSubstate.characterName = 'pico-holding-nene-dead';
					var firstTank:TankmenBG = new TankmenBG(20, 500, true);
					firstTank.resetShit(20, 1500, true,false);
					firstTank.strumTime = 10;
					firstTank.visible = false;
					tankmanRun.add(firstTank);

					for (i in 0...TankmenBG.animationNotes.length)
					{
						if (FlxG.random.bool(16))
						{
							var tankBih = tankmanRun.recycle(TankmenBG);
							if (VsliceOptions.SHADERS) applyShader(tankBih, ""); // Is this wasting resources? I don't know tbh
							tankBih.strumTime = TankmenBG.animationNotes[i][0];
							tankBih.scale.set(1, 1);
							tankBih.updateHitbox();
							tankBih.resetShit(500, 150, TankmenBG.animationNotes[i][1] < 2,false);
							// @:privateAccess
							// tankBih.endingOffset = 
							tankmanRun.add(tankBih);
						}
					}
					break;
				}
			}
		}
		cutscene?.preloadCutscene();
	}


	function applyAbotShader(sprite:FlxSprite){
		var rim = new DropShadowScreenspace();
		rim.setAdjustColor(-46, -38, -25, -20);
		rim.color = 0xFFDFEF3C;
		rim.antialiasAmt = 0;
		rim.attachedSprite = sprite;
		rim.distance = 5;
		rim.angle = 90;
		sprite.shader = rim;
		sprite.animation.callback = function(anim, frame, index)
		{
			rim.updateFrameInfo(sprite.frame);
			rim.curZoom = camGame.zoom;
		};
	}
	function applyShader(sprite:FlxSprite, char_name:String)
	{
		var rim = new DropShadowShader();
		rim.setAdjustColor(-46, -38, -25, -20);
		rim.color = 0xFFDFEF3C;
		rim.threshold = 0.3;
		rim.attachedSprite = sprite;
		rim.distance = 15;
		rim.strength = 1;
		rim.angle = 90;
		switch (char_name)
		{
			case "bf":
				{
					rim.threshold = 0.1;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
			case "gf-tankmen":
				{
					rim.setAdjustColor(-42, -10, 5, -25);
					rim.distance = 3;
					rim.threshold = 0.1;
					rim.altMaskImage = Paths.image("erect/masks/gfTankmen_mask").bitmap;
					rim.maskThreshold = 1;
					rim.useAltMask = true;

					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}

			case "tankman-bloody":
				{
					rim.angle = 135;
					rim.altMaskImage = Paths.image("erect/masks/tankmanCaptainBloody_mask").bitmap;
					rim.maskThreshold = 1;
					rim.threshold = 0.1;
					rim.useAltMask = true;

					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
			case "tankman":
				{
					rim.angle = 135;
					rim.threshold = 0.1;
					rim.maskThreshold = 1;
					rim.useAltMask = false;

					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
			case "nene":
				{
					rim.threshold = 0.1;
					rim.angle = 90;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
			default:
				{
					rim.angle = 90;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
		}
		sprite.shader = rim;
	}

}