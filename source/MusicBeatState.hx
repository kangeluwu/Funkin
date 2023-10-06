package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

class MusicBeatState extends FlxUIState
{
	public var curSection:Int = 0;
	private var stepsToDo:Int = 0;
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}

	override function update(elapsed:Float)
	{
		// everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
			{
				if(curStep > 0)
					stepHit();
	
				if(PlayState.SONG != null)
				{
					if (oldStep < curStep)
						updateSection();
					else
						rollbackSection();
				}

	}
	super.update(elapsed);
	}
	private function updateSection():Void
		{
			if(stepsToDo < 1) stepsToDo = 16;
			while(curStep >= stepsToDo)
			{
				curSection++;
				stepsToDo += 16;
				sectionHit();
			}
		}
	
		private function rollbackSection():Void
		{
			if(curStep < 0) return;
	
			var lastSection:Int = curSection;
			curSection = 0;
			stepsToDo = 0;
			for (i in 0...PlayState.SONG.notes.length)
			{
				if (PlayState.SONG.notes[i] != null)
				{
					stepsToDo += 16;
					if(stepsToDo > curStep) break;
					
					curSection++;
				}
			}
	
			if(curSection > lastSection) sectionHit();
		}

		
	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}
	public function sectionHit():Void
		{
			//trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
		}
}
