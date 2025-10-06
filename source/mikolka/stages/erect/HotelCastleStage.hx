package mikolka.stages.erect;

import states.stages.objects.*;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import shaders.DropShadowShader;
import states.PlayState;
import objects.Character;

class HotelCastleStage extends BaseStage {
	// Cutscene-related sprites
	private var fakeGooey:Null<BGSprite>;
	private var theBois:Null<BGSprite>;
	private var thoughts:Null<BGSprite>;
	private var bubble:Null<BGSprite>;

	// UI and control elements
	private var skipText:Null<FlxText>;

	// Cutscene state management
	private var canSkipCutscene:Bool = true;
	private var hasPlayedCutscene:Bool = false;
	private var cutsceneSkipped:Bool = false;

	// Character references
	private var stageCharacter:Null<Character>;
	private var characterType:String = "";

	override function create() {
		createBackgroundElements();
		createStageElements();
		createForegroundElements();
	}

	private function createBackgroundElements() {
		add(createBGSprite("gooeyMix/week60037/hotelCastle/backWall", -1000, -1000, 1.1, 1.1));

		var stageWall = createBGSprite("gooeyMix/week60037/hotelCastle/projWall", 360, -400, 0.9, 0.9, true);
		stageWall.animation.addByPrefix("morpho", "morpho", 12, true);
		stageWall.animation.play("morpho", true);
		add(stageWall);

		add(createBGSprite('gooeyMix/week60037/hotelCastle/backFrame', 870, -150, 0.95, 0.95));
		add(createBGSprite("gooeyMix/week60037/hotelCastle/wires", 570, -250, 0.975, 0.975));
	}

	private function createStageElements() {
		createLanterns();

		var morphoStage = new BGSprite("gooeyMix/week60037/hotelCastle/morphoStage", 549, 727);
		add(morphoStage);

		createCandles();
		createBoppers();
	}

	private function createLanterns() {
		add(createBGSprite("gooeyMix/week60037/hotelCastle/hangingLantern", 800, -100, 0.975, 0.975));
		add(createBGSprite("gooeyMix/week60037/hotelCastle/hangingLantern", 2240, -100, 0.975, 0.975));
		add(new BGSprite("gooeyMix/week60037/hotelCastle/lantern", 575, 770));
		add(new BGSprite("gooeyMix/week60037/hotelCastle/lantern", 2450, 750));
	}

	private function createCandles() {
		var candleBack = new BGSprite("gooeyMix/week60037/hotelCastle/candle", 2160, 720);
		candleBack.flipX = true;
		add(candleBack);

		var candleBackLight = createAnimatedBGSprite("gooeyMix/week60037/hotelCastle/candleFlame", 2120, 720, "flame", 12);
		candleBackLight.flipX = true;
		add(candleBackLight);

		var candleFront = new BGSprite("gooeyMix/week60037/hotelCastle/candle", 860, 940);
		add(candleFront);

		var candleFrontLight = createAnimatedBGSprite("gooeyMix/week60037/hotelCastle/candleFlame", 860, 940, "flame", 12);
		add(candleFrontLight);
	}

	private function createBoppers() {
		var boppers = createAnimatedBGSprite("gooeyMix/week60037/hotelCastle/ASMPbop1", -1000, -1000, "idleBop", 12);
		add(boppers);
	}

	private function createForegroundElements() {
		createLights();
	}

	private function createLights() {
		add(new BGSprite("gooeyMix/week60037/hotelCastle/spotlight1", -1000, -1000));
		add(new BGSprite("gooeyMix/week60037/hotelCastle/spotlight2", -1000, -1000));

		createLanternLights();
	}

	private function createLanternLights() {
		add(createBGSprite("gooeyMix/week60037/hotelCastle/lanternLight", 390, 620, 0.975, 0.975));
		add(createBGSprite("gooeyMix/week60037/hotelCastle/lanternLight", 2280, 600, 0.975, 0.975));
		add(createBGSprite("gooeyMix/week60037/hotelCastle/lanternLight", 625, 120, 0.975, 0.975));
		add(createBGSprite("gooeyMix/week60037/hotelCastle/lanternLight", 2070, 120, 0.975, 0.975));
	}

	override function createPost() {
		setupCharacterShader();
	}

	private function setupCharacterShader() {
		if (stageCharacter == null)
			return;

		var rim = new DropShadowShader();
		rim.setAdjustColor(0, 0, 0, 0);
		rim.color = 0xFF423427;
		stageCharacter.shader = rim;
		rim.attachedSprite = stageCharacter;
		rim.threshold = -1;

		switch (characterType) {
			case "bf":
				rim.angle = 67.5;
			case "gf":
				rim.angle = 90;
				rim.color = 0xFF000000;
			case "gooey":
				rim.angle = 67.5;
			default:
				rim.angle = 90;
				rim.threshold = 0.1;
		}
	}

	private function preloadGooeyCut() {
		setupSkipText();
		setupCutsceneCharacters();
		initializeCutsceneCamera();
	}

	private function setupSkipText() {
		skipText = new FlxText(936, 618, 0, 'Skip [ ADVANCE ]', 20);
		skipText.setFormat("vcr.ttf", 40, 0xFFFFFFFF, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
		skipText.scrollFactor.set();
		skipText.borderSize = 2;
		skipText.alpha = 0;
		add(skipText);
	}

	private function setupCutsceneCharacters() {
		if (PlayState.instance == null)
			return;

		PlayState.instance.camHUD.alpha = 0;

		stageCharacter = PlayState.instance.dad;
		if (stageCharacter != null) {
			stageCharacter.visible = false;
		}

		setupFakeGooey();
		setupBubble();
		setupThoughts();
		setupTheBois();
	}

	private function setupFakeGooey() {
		fakeGooey = new BGSprite("gooeyMix/week60037/hotelCastle/GooeyCut", 0, 0);
		setupGooeyAnimations();
		add(fakeGooey);
		fakeGooey.setPosition(-427, 727);
		fakeGooey.zIndex = 111;
		fakeGooey.scrollFactor.set(1.1, 1.1);
	}

	private function setupGooeyAnimations() {
		if (fakeGooey == null)
			return;

		addAnimation(fakeGooey, 'idle', 'balls', 12);
		addAnimation(fakeGooey, 'walk', 'walk', 12);
		addAnimation(fakeGooey, 'huh', 'huh', 12);
		addAnimation(fakeGooey, 'hmmm', 'hmmm', 12);
		addAnimation(fakeGooey, 'imSoSmart', 'imSoSmart', 12);
		addAnimation(fakeGooey, 'bye', 'bye', 24);
		addAnimation(fakeGooey, 'hi', 'hi', 12);
		fakeGooey.animation.play('idle');
	}

	private function setupBubble() {
		bubble = new BGSprite("gooeyMix/week60037/hotelCastle/GooeyCutBubble", 0, 0);
		bubble.animation.addByPrefix('idle', 'buble', 6, true);
		bubble.animation.play('idle');
		add(bubble);
		bubble.scrollFactor.set(0, 0);
		bubble.setPosition(FlxG.width - bubble.width, FlxG.height - bubble.height);
		bubble.zIndex = 300;
		bubble.alpha = 0;
		bubble.flipX = true;
		bubble.scale.set(1.3, 1.3);
	}

	private function setupThoughts() {
		thoughts = new BGSprite("gooeyMix/week60037/hotelCastle/GooeyCutBubble", 0, 0);
		setupThoughtsAnimations();
		add(thoughts);
		thoughts.scrollFactor.set(0, 0);
		thoughts.setPosition(FlxG.width - thoughts.width - 230, FlxG.height - thoughts.height + 200);
		thoughts.zIndex = 301;
	}

	private function setupThoughtsAnimations() {
		if (thoughts == null)
			return;

		addAnimation(thoughts, 'idle', 'blank', 12);
		addAnimation(thoughts, 'solike', 'solike', 12);
		addAnimation(thoughts, 'imBrokeAF', 'imBrokeAF', 12);
		addAnimation(thoughts, 'butWhatIf', 'butWhatIf', 12);
		addAnimation(thoughts, 'iRobMyFriends', 'iRobMyFriends', 12);
		addAnimation(thoughts, 'andUseTheMoney', 'andUseTheMoney', 12);
		addAnimation(thoughts, 'toWin', 'toWin', 12);
		addAnimation(thoughts, 'andGetMOREmoney', 'andGetMOREmoney', 12);
		addAnimation(thoughts, 'imSoFuckingSmart', 'imSoFuckingSmart', 12);
		thoughts.animation.play('idle');
	}

	private function setupTheBois() {
		theBois = new BGSprite("gooeyMix/week60037/hotelCastle/KamAndMatt", 0, 0);
		theBois.animation.addByPrefix('idle', 'talkLoop', 3, true);
		theBois.animation.addByPrefix('yoink', 'yoink', 12, false);
		theBois.animation.play('idle');
		add(theBois);
		theBois.scrollFactor.set(0, 0);
		theBois.setPosition(FlxG.width - theBois.width, FlxG.height - theBois.height);
		theBois.zIndex = 302;
		theBois.alpha = 0;
	}

	private function initializeCutsceneCamera() {
		if (PlayState.instance == null)
			return;

		FlxG.camera.fade(0xFF000000, 1, true);

		var cameraX = PlayState.instance.dad.x - 700;
		var cameraY = PlayState.instance.dad.y + 600;

		FlxTween.tween(FlxG.camera, {zoom: 1.1}, 0.5, {ease: FlxEase.expoOut});
		FlxTween.tween(FlxG.camera, {x: cameraX, y: cameraY}, 3, {ease: FlxEase.expoOut});
	}

	// Helper function to create BGSprite with scroll factors
	private function createBGSprite(key:String, x:Float, y:Float, scrollX:Float = 0, scrollY:Float = 0, animated:Bool = false):BGSprite {
		var sprite = new BGSprite(key, x, y);
		sprite.scrollFactor.set(scrollX, scrollY);
		return sprite;
	}

	// Helper function to create animated BGSprite
	private function createAnimatedBGSprite(key:String, x:Float, y:Float, animPrefix:String, frameRate:Int):BGSprite {
		var sprite = new BGSprite(key, x, y, 0, 0, true);
		sprite.animation.addByPrefix(animPrefix, animPrefix, frameRate, true);
		sprite.animation.play(animPrefix, true);
		return sprite;
	}

	// Helper function to add animations to a BGSprite
	private function addAnimation(sprite:BGSprite, animName:String, animPrefix:String, frameRate:Int, loop:Bool = false):Void {
		sprite.animation.addByPrefix(animName, animPrefix, frameRate, loop);
	}
}
