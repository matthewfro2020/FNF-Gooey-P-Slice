package mikolka.stages.scripts;

import flixel.util.FlxSignal;
import flixel.graphics.tile.FlxGraphicsShader;
import mikolka.vslice.StickerSubState;
import mikolka.compatibility.VsliceOptions;
#if !LEGACY_PSYCH
import objects.Note;
import substates.GameOverSubstate;
#else
using mikolka.compatibility.stages.misc.CharUtills;
#end

class GooeyCapableStage extends BaseStage
{
	final MIN_BLINK_DELAY:Int = 3;
	final MAX_BLINK_DELAY:Int = 7;
	final VULTURE_THRESHOLD:Float = 0.5;
	public final onABotInit:FlxTypedSignal<PicoCapableStage->Void> = new FlxTypedSignal();

	public static var instance:PicoCapableStage = null;
	public static var NENE_LIST = ['flora','flora-pixel', 'flora-christmas', 'flora-dark'];
	public static var PIXEL_LIST = ['flora-pixel'];

	public var abot:ABotSpeaker;
	public var abotPixel:ABotPixel;
	public var forceABot:Bool = false;
	var blinkCountdown:Int = 3;
	public function new(forceABot:Bool = false) {
		instance?.destroy();
		instance = this;
		super();
		this.forceABot = forceABot;
	}
	override function destroy() {
		instance = null;
		onABotInit.removeAll();
		super.destroy();
	}
	override function create() {
		
		if (!(NENE_LIST.contains(PlayState.SONG.gfVersion) || forceABot))
			return;	
		var _song = PlayState.SONG;
		#if !LEGACY_PSYCH if (_song.gameOverSound == null || _song.gameOverSound.trim().length < 1) #end
		GameOverSubstate.deathSoundName = 'fnf_loss_sfx-gooey';
		#if !LEGACY_PSYCH if (_song.gameOverLoop == null || _song.gameOverLoop.trim().length < 1) #end
		GameOverSubstate.loopSoundName = 'gameOver-gooey';
		#if !LEGACY_PSYCH if (_song.gameOverEnd == null || _song.gameOverEnd.trim().length < 1) #end
		GameOverSubstate.endSoundName = 'gameOverEnd-gooey';
		#if !LEGACY_PSYCH if (_song.gameOverChar == null || _song.gameOverChar.trim().length < 1) #end
		GameOverSubstate.characterName = 'gooey';
	}
	override function createPost()
	{
		super.createPost();
		var game = PlayState.instance;
                StickerSubState.STICKER_SET = "stickers-set-gooey";
	}

	override function gameOverStart(state:GameOverSubstate)
	{
		if (['gooey', 'gooey-christmas'].contains(GameOverSubstate.characterName))
		{

			state.boyfriend.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int)
			{
				switch (name)
				{
					case 'firstDeath':
						if (frameNumber >= 36 - 1)
						{
							overlay.visible = true;
							overlay.animation.play('deathLoop');
							state.boyfriend.animation.callback = null;
						}
					default:
						state.boyfriend.animation.callback = null;
				}
			}
	}
}