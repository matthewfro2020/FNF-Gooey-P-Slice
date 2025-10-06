package mikolka.stages.cutscenes;

import flixel.sound.FlxSound;
import openfl.filters.ShaderFilter;
import shaders.DropShadowScreenspace;
import mikolka.stages.erect.TankErect;
#if !LEGACY_PSYCH
import cutscenes.CutsceneHandler;
#end
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import states.PlayState;

class GooeyTankman {
    private var stage:TankErect;
    private var gooeyCutSound:FlxSound;
    private var tankmanGooeyCutscene:FlxSprite; // Changed from FlxAtlasSprite
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
    
    // New private variable to replace missing tankmanGroup
    private var tankmanGroup:FlxSprite;
    
    public function new(stage:TankErect) {
        this.stage = stage;
    }
    
    public function startGooeyTankmanCutscene() {
        preloadCutscene();
        gooeyStressCutscene();
    }
    
    private function preloadCutscene() {
        // Use FlxSound.loadSound instead of FlxSound.load
        gooeyCutSound = FlxSound.loadSound(Paths.sound('stressGooeyCutscene/lines/1'), 1.0);
        gooeyCutSound.volume = 1;

        // Replace girlfriend() with a more generic character method
        PlayState.instance.characterGroup.girlfriend.playAnimation('tankFrozen', true, true);

        // Modify skip text creation
        skipText = new FlxText(936, 618, 0, 'Skip [ ENTER ]', 20);
        skipText.setFormat(Paths.font('vcr.ttf'), 40, 0xFFFFFFFF, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
        skipText.scrollFactor.set();
        skipText.borderSize = 2;
        skipText.alpha = 0;
        
        // Use a more generic method to add text to the stage
        if (PlayState.instance.currentStage != null) {
            PlayState.instance.currentStage.add(skipText);
        }

        // Use inCutscene camera instead of camCutscene
        skipText.cameras = [PlayState.instance.inCutscene];
    }
    
    private function gooeyStressCutscene() {
        // Check if the current variation is 'gooey'
        if (PlayState.instance.stageData.variation != 'gooey') return;
        
        // Use characterGroup methods for camera focus points
        var gooeyPos:Array<Float> = [
            PlayState.instance.characterGroup.boyfriend.cameraFocusPoint.x,
            PlayState.instance.characterGroup.boyfriend.cameraFocusPoint.y
        ];
        
        var kamPos:Array<Float> = [
            PlayState.instance.characterGroup.girlfriend.cameraFocusPoint.x,
            PlayState.instance.characterGroup.girlfriend.cameraFocusPoint.y
        ];
        
        var tankmanPos:Array<Float> = [
            PlayState.instance.characterGroup.dad.cameraFocusPoint.x,
            PlayState.instance.characterGroup.dad.cameraFocusPoint.y
        ];

        cutsceneTimerManager = new FlxTimerManager();
        PlayState.instance.inCutscene.fade(0xFF000000, 1, true, null, true);

        // Additional cutscene logic would go here
    }
    
    private function skipCutscene() {
        // Check if the current variation is 'gooey'
        if (PlayState.instance.stageData.variation != 'gooey') return;
        
        cutsceneSkipped = true;
        hasPlayedCutscene = true;
        
        PlayState.instance.inCutscene.fade(0xFF000000, 0.5, false, null, true);
        cutsceneMusic.fadeOut(0.5, 0);
        
        if (gooeyCutSound != null) {
            gooeyCutSound.fadeOut(0.5, 0);
        }

        new FlxTimer().start(0.5, function(_) {
            tankmanGooeyCutscene.destroy();
            PlayState.instance.justUnpaused = true;
            PlayState.instance.inCutscene.fade(0xFF000000, 0.5, true, null, true);

            cutsceneTimerManager.clear();
            cutsceneMusic.stop();
            
            if (gooeyCutSound != null) {
                gooeyCutSound.stop();
            }

            PlayState.instance.startCountdown();
            skipText.visible = false;

            // Safely destroy sprites
            if (tankBopLeft != null) tankBopLeft.destroy();
            if (tankBopRight != null) tankBopRight.destroy();
            if (fakeFlora != null) fakeFlora.destroy();
            if (floraEyes != null) floraEyes.destroy();
            
            FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, 1);

            // Use characterGroup for visibility and animations
            PlayState.instance.characterGroup.girlfriend.visible = true;
            PlayState.instance.characterGroup.boyfriend.visible = true;
            PlayState.instance.characterGroup.dad.visible = true;

            PlayState.instance.characterGroup.girlfriend.playAnimation('idle', true);
            PlayState.instance.characterGroup.dad.playAnimation('idle', true);
            PlayState.instance.characterGroup.boyfriend.playAnimation('idle', true);
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
            // Use a more generic removal method
            PlayState.instance.currentStage.remove(tankmanGroup);
            tankmanGroup.destroy();
            tankmanGroup = null;
        }
    }
}