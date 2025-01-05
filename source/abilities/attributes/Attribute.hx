package abilities.attributes;

import haxe.ds.HashMap;

class Attribute {

	public static var MOVEMENT_SPEED:AttributeType = new AttributeType("movement_speed", 1, 150, 1200);
	public static var ATTACK_DAMAGE:AttributeType = new AttributeType("attack_damage", 1, 0.1, 10);
	public static var JUMP_HEIGHT:AttributeType = new AttributeType("jump_height", 0.5, 50);
	public static var MAX_HEALTH:AttributeType = new AttributeType("health", 1, 25);

	public static var SIZE_X:AttributeType = new AttributeType("size_x", 0.001, 0.45, 2);
	public static var SIZE_Y:AttributeType = new AttributeType("size_y", 0.001, 0.45, 2);
	public static var ATTACK_SPEED:AttributeType = new AttributeType("attack_speed", 1, 0.001, 0.1);

	public static var DASH_SPEED:AttributeType = new AttributeType("player.dash_speed", 1, 150, 600);
	public static var JUMP_COUNT:AttributeType = new AttributeType("player.jump_count", 1, 0, 99999999999999999999999, true);
	public static var CRIT_CHANCE:AttributeType = new AttributeType("player.crit_chance", 0.1, 1, 100);

	public static var attributesList = [
		MOVEMENT_SPEED,
		ATTACK_DAMAGE,
		JUMP_HEIGHT,
		MAX_HEALTH,
		SIZE_X,
		DASH_SPEED,
		JUMP_COUNT,
		CRIT_CHANCE
	];


    public var defaultValue = 0.0;
    private var value = 0.0;
    public var modifiers:Array<AttributeContainer> = new Array();

	public var min = 0.0;
	public var max = 0.0;

    public function new(defaultAmount) {
        defaultValue = defaultAmount;
        value = defaultAmount;
    }

    public function refreshAndGetValue():Float {
        var finalValue = defaultValue;
		var firstAddValue = 0.0;
        for (i in modifiers) {
			if (i.operation == AttributeOperation.FIRST_ADD)
			{
				finalValue += i.amount; 
				firstAddValue += i.amount;
			}
		}
		for (i in modifiers)
		{
            if (i.operation == AttributeOperation.ADD) finalValue += i.amount;
            else if (i.operation == AttributeOperation.MULTIPLY) finalValue *= i.amount;
        }
		if (finalValue >= max)
		{
			finalValue = max + firstAddValue;
		}
		if (finalValue <= min)
		{
			finalValue = min + firstAddValue;
		}
        value = finalValue;
        return finalValue;
    }

    public function removeOperation(container:AttributeContainer) {
        modifiers.remove(container);
        refreshAndGetValue();
    }
	public function containsOperation(container:AttributeContainer):Bool
	{
		return modifiers.contains(container);
	}

    public function addOperation(container:AttributeContainer) {
		if (!modifiers.contains(container))
		{
			modifiers.push(container);
			refreshAndGetValue();
		}
    }

    public function getValue():Float {
        return value;
    }

	public static function parseOperation(string:String):AttributeOperation
	{
		if (string == "add")
			return AttributeOperation.ADD;
		if (string == "first_add")
			return AttributeOperation.FIRST_ADD;
		if (string == "multiply")
			return AttributeOperation.MULTIPLY;
		return AttributeOperation.ADD;
	}

}