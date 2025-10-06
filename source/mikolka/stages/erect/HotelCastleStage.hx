package mikolka.stages.erect;

import states.stages.objects.*;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import shaders.DropShadowShader;

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

  override function create() {
    // Background layers
    createBackgroundElements();
    createStageElements();
    createForegroundElements();
  }

  private function createBackgroundElements() {
    var backWall = new BGSprite("gooeyMix/week60037/hotelCastle/backWall", -1000, -1000);
    backWall.scrollFactor.set(1.1, 1.1);
    add(backWall);

    var stageWall = new BGSprite("gooeyMix/week60037/hotelCastle/projWall", 360, -400, true, 0, 0, true);
    stageWall.animation.addByPrefix("morpho", "morpho", 12, true);
    stageWall.scrollFactor.set(0.9, 0.9);
    stageWall.animation.play("morpho", true);
    add(stageWall);

    var backFrame = new BGSprite('gooeyMix/week60037/hotelCastle/backFrame', 870, -150);
    backFrame.scrollFactor.set(0.95, 0.95);
    add(backFrame);

    var wires = new BGSprite("gooeyMix/week60037/hotelCastle/wires", 570, -250);
    wires.scrollFactor.set(0.975, 0.975);
    add(wires);
  }

  private function createStageElements() {
    // Lanterns
    createLanterns();
    
    // Stage and Candles
    var morphoStage = new BGSprite("gooeyMix/week60037/hotelCastle/morphoStage", 549, 727);
    add(morphoStage);

    createCandles();
    createBoppers();
  }

  private function createLanterns() {
    var topLantern1 = new BGSprite("gooeyMix/week60037/hotelCastle/hangingLantern", 800, -100);
    topLantern1.scrollFactor.set(0.975, 0.975);
    add(topLantern1);

    var topLantern2 = new BGSprite("gooeyMix/week60037/hotelCastle/hangingLantern", 2240, -100);
    topLantern2.scrollFactor.set(0.975, 0.975);
    add(topLantern2);

    var bottomLantern1 = new BGSprite("gooeyMix/week60037/hotelCastle/lantern", 575, 770);
    add(bottomLantern1);

    var bottomLantern2 = new BGSprite("gooeyMix/week60037/hotelCastle/lantern", 2450, 750);
    add(bottomLantern2);
  }

  private function createCandles() {
    var candleBack = new BGSprite("gooeyMix/week60037/hotelCastle/candle", 2160, 720);
    candleBack.flipX = true;
    add(candleBack);

    var candleBackLight = new BGSprite("gooeyMix/week60037/hotelCastle/candleFlame", 2120, 720, true, 0, 0, true);
    candleBackLight.animation.addByPrefix("flame", "flame", 12, true);
    candleBackLight.flipX = true;
    candleBackLight.animation.play("flame", true);
    add(candleBackLight);

    var candleFront = new BGSprite("gooeyMix/week60037/hotelCastle/candle", 860, 940);
    add(candleFront);

    var candleFrontLight = new BGSprite("gooeyMix/week60037/hotelCastle/candleFlame", 860, 940, true, 0, 0, true);
    candleFrontLight.animation.addByPrefix("flame", "flame", 12, true);
    candleFrontLight.animation.play("flame", true);
    add(candleFrontLight);
  }

  private function createBoppers() {
    var boppers = new BGSprite("gooeyMix/week60037/hotelCastle/ASMPbop1", -1000, -1000, true, 0, 0, true);
    boppers.animation.addByPrefix("idle", "idleBop", 12, true);
    boppers.animation.play("idle", true);
    add(boppers);
  }

  private function createForegroundElements() {
    createLights();
  }

  private function createLights() {
    var spotlight1 = new BGSprite("gooeyMix/week60037/hotelCastle/spotlight1", -1000, -1000);
    add(spotlight1);

    var spotlight2 = new BGSprite("gooeyMix/week60037/hotelCastle/spotlight2", -1000, -1000);
    add(spotlight2);

    createLanternLights();
  }

  private function createLanternLights() {
    var bottomLantern1Light = new BGSprite("gooeyMix/week60037/hotelCastle/lanternLight", 390, 620);
    bottomLantern1Light.scrollFactor.set(0.975, 0.975);
    add(bottomLantern1Light);

    var bottomLantern2Light = new BGSprite("gooeyMix/week60037/hotelCastle/lanternLight", 2280, 600);
    bottomLantern2Light.scrollFactor.set(0.975, 0.975);
    add(bottomLantern2Light);

    var topLantern1Light = new BGSprite("gooeyMix/week60037/hotelCastle/lanternLight", 625, 120);
    topLantern1Light.scrollFactor.set(0.975, 0.975);
    add(topLantern1Light);

    var topLantern2Light = new BGSprite("gooeyMix/week60037/hotelCastle/lanternLight", 2070, 120);
    topLantern2Light.scrollFactor.set(0.975, 0.975);
    add(topLantern2Light);
  }

  override function createPost() {
    setupCharacterShader();
  }

  private function setupCharacterShader() {
    var rim = new DropShadowShader();
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
        rim.angle = 90;
        rim.threshold = 0.1;
        sprite.shader = rim;
        sprite.animation.callback = function(anim, frame, index) {
          rim.updateFrameInfo(sprite.frame);
        };
    }
  }

  function preloadGooeyCut() {
    setupSkipText();
    setupCutsceneCharacters();
    initializeCutsceneCamera();
  }

  private function setupSkipText() {
    skipText = new FlxText(936, 618, 0, 'Skip [ ' + PlayState.instance.controls.getDialogueNameFromToken("CUTSCENE_ADVANCE", true) + ' ]', 20);
    skipText.setFormat(Paths.font('vcr.ttf'), 40, 0xFFFFFFFF, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
    skipText.scrollFactor.set();
    skipText.borderSize = 2;
    skipText.alpha = 0;
    add(skipText);
  }

  private function setupCutsceneCharacters() {
    PlayState.instance.camHUD.alpha = 0;
    PlayState.instance.dad().visible = false;

    setupFakeGooey();
    setupBubble();
    setupThoughts();
    setupTheBois();
  }

  private function setupFakeGooey() {
    fakeGooey = new BGSprite(0, 0).loadSparrow('gooeyMix/week60037/hotelCastle/GooeyCut');
    setupGooeyAnimations();
    add(fakeGooey);
    fakeGooey.setPosition(-427, 727);
    fakeGooey.zIndex = 111;
    fakeGooey.scrollFactor.set(1.1, 1.1);
  }

  private function setupGooeyAnimations() {
    if (fakeGooey == null) return;
    
    fakeGooey.animation.addByPrefix('idle', 'balls', 12, false);
    fakeGooey.animation.addByPrefix('walk', 'walk', 12, false);
    fakeGooey.animation.addByPrefix('huh', 'huh', 12, false);
    fakeGooey.animation.addByPrefix('hmmm', 'hmmm', 12, false);
    fakeGooey.animation.addByPrefix('imSoSmart', 'imSoSmart', 12, false);
    fakeGooey.animation.addByPrefix('bye', 'bye', 24, false);
    fakeGooey.animation.addByPrefix('hi', 'hi', 12, false);
    fakeGooey.animation.play('idle');
  }

  private function setupBubble() {
    bubble = new BGSprite(0, 0).loadSparrow('gooeyMix/week60037/hotelCastle/GooeyCutBubble');
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
    thoughts = new BGSprite(0, 0).loadSparrow('gooeyMix/week60037/hotelCastle/GooeyCutBubble');
    setupThoughtsAnimations();
    add(thoughts);
    thoughts.scrollFactor.set(0, 0);
    thoughts.setPosition(FlxG.width - thoughts.width - 230, FlxG.height - thoughts.height + 200);
    thoughts.zIndex = 301;
  }

  private function setupThoughtsAnimations() {
    if (thoughts == null) return;

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
  }

  private function setupTheBois() {
    theBois = new BGSprite(0, 0).loadSparrow('gooeyMix/week60037/hotelCastle/KamAndMatt');
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
    refresh();
    FlxG.camera.fade(0xFF000000, 1, true);
    var gooeyPos:Array<Float> = [
      getDad().cameraFocusPoint.x,
      getDad().cameraFocusPoint.y
    ];
    PlayState.instance.tweenCameraZoom(1.1, 0.5, true, FlxEase.expoOut);
    PlayState.instance.tweenCameraToPosition(gooeyPos[0] - 700, gooeyPos[1] + 600, 3, FlxEase.expoOut);
  }
}