package;

import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var char:String = '';
	var isPlayer:Bool = false;
    var disCharsReal:Array<String> = ['bf-pixel','bf-old','bf-main','pico-d1',
	'pico-d2','pico-d3',
	'dad-d1','dad-d2','dad-d3','dad-d3-ded','gf-main','pico-main',
	'dad-d1-alt','dad-d2-alt','dad-d3-alt','dad-d3-ded-alt'];
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		this.isPlayer = isPlayer;

		changeIcon(char);
		antialiasing = true;
		scrollFactor.set();
	}

	public var isOldIcon:Bool = false;

	public function swapOldIcon():Void
	{
		isOldIcon = !isOldIcon;

		if (isOldIcon)
			changeIcon('bf-old');
		else
			changeIcon(PlayState.SONG.player1);
	}

	public function changeIcon(newChar:String):Void
	{
		var useSplit = true;
		var usedAlt = false;
		var usedAlt2 = false;
	for (real in disCharsReal){
		if (newChar == real)
			useSplit = false;
		if (newChar + '-alt' == real)
			usedAlt = true;
		}

		if (useSplit)
			newChar = newChar.split('-')[0].trim();
		var file = newChar;
		switch (newChar){
			case 'dad-d1-alt':
				usedAlt2 = true;
				file = 'dad-d1';
			case 'dad-d2-alt':
				usedAlt2 = true;
				file = 'dad-d2';
			case 'dad-d3-ded-alt':
				usedAlt2 = true;
				file = 'dad-d3-ded';
		}
		if (newChar != char)
		{
			if (animation.getByName(newChar) == null)
			{
				loadGraphic(Paths.image('icons/icon-' + file), true, 150, 150);
				var curF = [0,1];
				if (usedAlt)
					curF = [0,0];
				if (usedAlt2)
					curF = [1,1];
				animation.add(newChar, curF, 0, false, isPlayer);
			}
			animation.play(newChar);
			char = newChar;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
