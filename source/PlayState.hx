package;

import abilities.attributes.Attribute;
import abilities.attributes.AttributeContainer;
import abilities.attributes.AttributeOperation;
import entity.Entity;
import entity.EquippedEntity;
import entity.PlayerEntity;
import entity.bosses.BIGEVILREDCUBE;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.mappings.SwitchProMapping;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import input.ControllerSource;
import input.KeyboardSource;
import nape.geom.Vec2;
import objects.FootstepChangingSprite;
import objects.ImmovableFootstepChangingSprite;
import objects.SlotMachine;
import objects.SpriteToInteract;
import objects.hitbox.Hitbox;
import substate.PauseSubState;
import substate.SlotsSubState;
import ui.InGameHUD;
import util.EnviornmentsLoader;
import util.Language;
import util.Projectile;
import util.SubtitlesBox;

class PlayState extends FlxState
{

	var playerMarkerColors = [
		FlxColor.BLUE,
		FlxColor.RED,
		FlxColor.GREEN,
		FlxColor.YELLOW,
		FlxColor.PURPLE,
		FlxColor.CYAN,
		FlxColor.LIME,
		FlxColor.ORANGE,
		FlxColor.WHITE,
		FlxColor.BROWN,
		FlxColor.PINK
	];
	var playerDebugText:FlxText = new FlxText(10,10,0);

	public var mapLayerFront:FlxSpriteGroup = new FlxSpriteGroup();
	public var mapLayerBehind:FlxSpriteGroup = new FlxSpriteGroup();
	public var interactable:FlxSpriteGroup = new FlxSpriteGroup();
	public var mapLayer:FlxSpriteGroup = new FlxSpriteGroup();
	public var playerLayer:FlxSpriteGroup = new FlxSpriteGroup();
	public var enemyLayer:FlxSpriteGroup = new FlxSpriteGroup();
	var gameCam:FlxCamera = new FlxCamera();
	var HUDCam:FlxCamera = new FlxCamera();

	public var gameHud:InGameHUD = new InGameHUD();

	override function destroy()
	{
		Main.napeSpace.clear();
		super.destroy();
	}

	override public function create()
	{
		super.create();
		Main.audioPanner = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
		Main.audioPanner.makeGraphic(1, 1, FlxColor.TRANSPARENT);
		FlxG.cameras.reset(gameCam);
		HUDCam.bgColor.alpha = 0;
		FlxG.cameras.add(HUDCam, false);
		var bg = new FlxSprite(0, 0, AssetPaths.test_bg__png);
		bg.alpha = 0.2;
		add(bg);
		var ground = new ImmovableFootstepChangingSprite(FlxG.width / 2, 1080, "concrete");
		ground.makeGraphic(1920, 250, FlxColor.TRANSPARENT);
		ground.immovable = true;
		mapLayerFront.add(ground);
		var roof = new ImmovableFootstepChangingSprite(FlxG.width / 2, 0, "concrete");
		roof.makeGraphic(1920, 250, FlxColor.TRANSPARENT);
		roof.immovable = true;
		mapLayerFront.add(roof);
		var wall = new ImmovableFootstepChangingSprite(0, 537, "concrete");
		wall.makeGraphic(378, 1080, FlxColor.TRANSPARENT);
		wall.immovable = true;
		mapLayerFront.add(wall);
		var wall2 = new ImmovableFootstepChangingSprite(FlxG.width, 537, "concrete");
		wall2.makeGraphic(378, 1080, FlxColor.TRANSPARENT);
		wall2.immovable = true;
		mapLayerFront.add(wall2);
		var enviornment = new FlxSprite(0, 0);
		var bgName = EnviornmentsLoader.enviornments[FlxG.random.int(0, EnviornmentsLoader.enviornments.length - 1)];
		enviornment.loadGraphic(bgName, true, 1280, 720);
		enviornment.setGraphicSize(1920, 1080);
		enviornment.updateHitbox();
		var frames = [];
		for (i in 0...Math.floor(enviornment.width / 1280) + 1)
		{
			frames.push(i);
		}
		enviornment.animation.add("idle", frames, 2);
		enviornment.animation.play("idle");
		var enviornmentbg = new FlxSprite(0, 0);
		enviornmentbg.loadGraphic(StringTools.replace(StringTools.replace(bgName, "enviorments", "backgrounds"), ".png", "_back.png"), true, 1280, 720);
		enviornmentbg.setGraphicSize(1920, 1080);
		enviornmentbg.updateHitbox();
		enviornmentbg.animation.add("idle", frames, 2);
		enviornmentbg.animation.play("idle");
		add(subtitles);
		subtitles.visible = false;
		subtitles.camera = HUDCam;
		// playerLayer.add(new PlayerEntity(900, 20, "Player 1"));
		if (bgName == AssetPaths.winbig__png)
		{
			ground.footstepSoundName = "carpet";
			/*var table = new FootstepChangingSprite(FlxG.random.int(300, 1200), ground.y - 16, "wood");
			table.loadGraphic(AssetPaths.table__png);
			table.createRectangularBody();
			table.body.space = Main.napeSpace;
			table.setBodyMaterial(-1, 4, 4, 2, 0);
			table.immovable = true;
					mapLayerBehind.add(table); */
		}
		var slotMachine = new SlotMachine(FlxG.random.int(300, 1200), ground.y - 264);
		slotMachine.loadGraphic(AssetPaths.slot_machine__png);
		slotMachine.immovable = true;
		slotMachine.offset.y = 12;
		slotMachine.setSize(72, 132);
		interactable.add(slotMachine);
		mapLayer.add(mapLayerBehind);
		mapLayer.add(mapLayerFront);

		playerDebugText.size = 12;
		playerDebugText.visible = false;
		add(enviornmentbg);
		add(mapLayerBehind);
		add(interactable);
		add(enemyLayer);
		add(playerLayer);
		add(mapLayerFront);
		add(enviornment);
		playerDebugText.camera = HUDCam;
		add(playerDebugText);
		gameHud.camera = HUDCam;
		add(gameHud);
	}
	var subtitles = new SubtitlesBox();
	var takenInputs = [];
	var kmbConnected = false;

	override public function update(elapsed:Float)
	{
		for (sprite in interactable)
		{
			if (sprite is SpriteToInteract)
			{
				cast(sprite, SpriteToInteract).showTip = false;
			}
		}
		if (Main.napeSpace != null && elapsed > 0)
		{
			Main.napeSpace.step(elapsed);
		}
		Main.detectConnections();
		if (Main.connectionsDirty)
		{
			for (i in Main.activeInputs)
			{
				if (!takenInputs.contains(i))
				{
					var player = new PlayerEntity(900, 20, "Player " + (playerLayer.length + 1));
					player.input = i;
					playerLayer.add(player);
					player.screenCenter();
					takenInputs.push(i);
				}
			}
		}
		var pressedDebugSpawn = false;

		for (i in Main.activeGamepads)
		{
			if (i.justPressed.RIGHT_STICK_CLICK)
			{
				pressedDebugSpawn = true;
			}
		}

		#if FLX_DEBUG
			if (FlxG.keys.justPressed.G)
			{
				FlxG.vcr.startRecording(false);
			}
				if (FlxG.keys.justPressed.H)
				{
					var recording = FlxG.vcr.stopRecording();
					FlxG.vcr.loadReplay(recording);
				}
		#end
		if (FlxG.keys.justPressed.I || pressedDebugSpawn)
		{
			enemyLayer.add(new BIGEVILREDCUBE(FlxG.width / 2, FlxG.height / 2));
		}
		if (FlxG.keys.justPressed.THREE)
		{
			playerDebugText.visible = !playerDebugText.visible;
		}
		if (FlxG.keys.justPressed.K)
		{
			subtitles.visible = !subtitles.visible;
		}
		FlxG.fixedTimestep = false;
		FlxG.autoPause = false;
		var showPlayerMarker = playerLayer.length > 1;
		gameCam.pixelPerfectRender = true;
		playerDebugText.text = "\n" + "FPS: " + Main.FPS.currentFPS + "\n";
		var currentBarHeight = 0.0;
		var currentBarIndex = 0;
		enemyLayer.forEachOfType(Entity, (p) ->
		{
			if (!p.alive)
			{
				enemyLayer.remove(p, true);
				if (p.ragdoll != null)
				{
					p.ragdoll.body.position.setxy(-1000, -1000);
					p.ragdoll.destroy();
				}
				p.destroy();
				return;
			}
			if (p.bossHealthBar)
			{
				currentBarIndex++;
				p.healthBar.screenCenter(X);
				p.healthBar.y = (80 * currentBarIndex) + currentBarHeight;
				p.nametag.screenCenter(X);
				p.nametag.y = p.healthBar.y - 40;
				currentBarHeight += p.healthBar.height;
				p.healthBar.camera = HUDCam;
				p.nametag.camera = HUDCam;
			}
		});
		enemyLayer.forEachOfType(EquippedEntity, (p) ->
		{
			FlxG.collide(mapLayer, p.blood, (m, p2) ->
			{
				if (p2 is FlxParticle)
				{
					var part:FlxParticle = cast(p2);
					part.velocity.set(0, 0);
				}
			});
			for (hitbox in p.hitboxes)
			{
				FlxG.overlap(hitbox, this, (h, e) ->
				{
					if (e is Entity)
					{
						if (h is Hitbox)
						{
							var e2:Entity = cast(e);
							var hitbox:Hitbox = cast(h);
							if (!hitbox.hitEntities.contains(e2))
							{
								h.onHit(e2);
							}
						}
					}
				});
			}
		});
		playerLayer.forEachOfType(PlayerEntity, (p) ->
		{
			FlxG.collide(p.hitboxes, mapLayer, (c:Hitbox, e) ->
			{
				c.onHitWall();
			});
			FlxG.overlap(p.collideables, enemyLayer, (c:Projectile, e:Entity) ->
			{
				c.onOverlapWithEntity(e);
			});
			FlxG.overlap(p.collideables, playerLayer, (c:Projectile, e:Entity) ->
			{
				c.onOverlapWithEntity(e);
			});
			FlxG.overlap(p.collideables, mapLayer, (c:Projectile, e:Entity) ->
			{
				c.onOverlapWithMap();
			});
			p.healthBar.camera = HUDCam;
			FlxG.collide(mapLayer, p.blood, (m, p2) ->
			{
				if (p2 is FlxParticle)
				{
					var part:FlxParticle = cast(p2);
					part.velocity.set(0, 0);
				}
			});
			for (hitbox in p.hitboxes)
			{
				FlxG.overlap(hitbox, this, (h, e) ->
				{
					if (e is Entity)
					{
						if (h is Hitbox)
						{
							var e2:Entity = cast(e);
							var hitbox:Hitbox = cast(h);
							if (!hitbox.hitEntities.contains(e2))
							{
								h.onHit(e2);
							}
						}
					}
				});
			}
			if (FlxG.keys.justPressed.ESCAPE)
			{
				var tempState:PauseSubState = new PauseSubState();
				openSubState(tempState);
			}
			var isInteractingWithSlots = false;
			FlxG.overlap(p, interactable, (a, b) ->
			{
				if (b is SpriteToInteract)
				{
					var sti = cast(b, SpriteToInteract);
					sti.showTip = true;
					if (b is SlotMachine)
					{
						isInteractingWithSlots = true;
					}
				}
			});
			if (p.input.interactJustPressed && isInteractingWithSlots)
			{
				openSubState(new SlotsSubState(p));
			}
			if (p.playerMarkerColor == FlxColor.TRANSPARENT)
			{
				p.playerMarkerColor = playerMarkerColors[0];
				playerMarkerColors.splice(0,1);
			}
			p.showPlayerMarker = showPlayerMarker;
			playerDebugText.text += p.toString() + "\n\n";
		});
		noEpilepsy -= elapsed;
		if (gambaTime != -1)
			gambaTime += elapsed;
		super.update(elapsed);
		FlxG.collide(playerLayer, mapLayer, playerWallCollision);
		// FlxG.collide(playerLayer, enemyLayer);
		FlxG.collide(enemyLayer, mapLayer, playerWallCollision);
	}
	var gambaText1 = "";
	var gambaText2 = "";
	var gambaText3 = "";
	var gambaTime = -1.0;
	var noEpilepsy = 0.0;


	public function playerWallCollision(player:Entity, wall:FlxSprite)
	{
		if (wall is FootstepChangingSprite)
		{
			player.steppingOn = cast(wall, FootstepChangingSprite).footstepSoundName;
		}
	}
}
