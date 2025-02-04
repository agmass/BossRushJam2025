package util;

import entity.Entity;
import flixel.addons.nape.FlxNapeSprite;

/*
 * Projectiles are physics based and should be used for sillier or more skillfull weapon output
 * For predictable weapon output, extend Hitbox instead
 */

class Projectile extends FlxNapeSprite
{
	public var shooter:Entity;
	public var returnToShooter = false;
	public var networked = false;
	public var networkLerper:NetworkPositionLerper;

	override public function new(x, y, a, c, e)
	{
		super(x, y, a, c, e);
		networkLerper = new NetworkPositionLerper(this);
	}

	public function onOverlapWithEntity(entity:Entity) {}
	public function onOverlapWithMap() {}
}