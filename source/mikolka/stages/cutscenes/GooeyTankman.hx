package mikolka.stages.cutscenes;

import openfl.filters.ShaderFilter;
import shaders.DropShadowScreenspace;
import mikolka.stages.erect.TankErect;
#if !LEGACY_PSYCH
import cutscenes.CutsceneHandler;
#end
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;

class GooeyTankman {
    private var stage:TankErect;
    private var gooeyCutSound:FlxSound;
    private var tankmanGooeyCutscene:FlxAtlasSprite;
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
    
    public function new(stage:TankErect) {
        this.stage = stage;
    }
    
    public function startGooeyTankmanCutscene() {
        preloadCutscene();
        gooeyStressCutscene();
    }
    
    private function preloadCutscene() {
        gooeyCutSound = FlxSound.load(Paths.sound('stressGooeyCutscene/lines/1'), 1.0, false);
        gooeyCutSound.volume = 1;

        PlayState.instance.girlfriend().playAnimation('tankFrozen', true, true);
        // event.cancel(); // Commented out as context is missing

        skipText = new FlxText(936, 618, 0, 'Skip [ ' + PlayState.instance.controls.getDialogueNameFromToken("CUTSCENE_ADVANCE", true) + ' ]', 20);
        skipText.setFormat(Paths.font('vcr.ttf'), 40, 0xFFFFFFFF, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
        skipText.scrollFactor.set();
        skipText.borderSize = 2;
        skipText.alpha = 0;
        PlayState.instance.currentStage.add(skipText);

        skipText.cameras = [PlayState.instance.camCutscene];

        // Rest of the preload logic remains the same as in the original code
        // ... (Add the rest of the preloadCutscene method from the original code)
    }
    
    private function gooeyStressCutscene() {
        if (PlayState.instance.currentVariation != 'gooey') return;
        
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

        // Rest of the gooeyStressCutscene method remains the same as in the original code
        // ... (Add the rest of the gooeyStressCutscene method from the original code)
    }
    
    private function skipCutscene() {
        if (PlayState.instance.currentVariation != 'gooey') return;
        
        cutsceneSkipped = true;
        hasPlayedCutscene = true;
        
        PlayState.instance.camCutscene.fade(0xFF000000, 0.5, false, null, true);
        cutsceneMusic.fadeOut(0.5, 0);
        
        if (gooeyCutSound != null) {
            gooeyCutSound.fadeOut(0.5, 0);
        }

        new FlxTimer().start(0.5, function(_) {
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
        
        new FlxTimer().start(1, function(_) {
            FlxG.cameras.remove(gooeyrimlightCamera);
            gooeyrimlightCamera.destroy();
        });
    }
    
    private function kill():Void {
        cleanupTankmanGroup();
    }
    
    private function cleanupTankmanGroup():Void {
        if (tankmanGroup != null) {
            PlayState.instance.currentStage.remove(tankmanGroup);
            tankmanGroup.destroy();
            tankmanGroup = null;
        }
    }
}