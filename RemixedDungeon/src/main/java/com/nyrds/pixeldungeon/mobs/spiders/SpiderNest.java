package com.nyrds.pixeldungeon.mobs.spiders;

import com.nyrds.pixeldungeon.ai.MobAi;
import com.nyrds.pixeldungeon.ai.Sleeping;
import com.nyrds.pixeldungeon.mobs.common.MobSpawner;
import com.watabou.pixeldungeon.Dungeon;
import com.watabou.pixeldungeon.actors.Char;
import com.watabou.pixeldungeon.actors.mobs.Mob;
import com.watabou.pixeldungeon.items.potions.PotionOfHealing;

public class SpiderNest extends Mob {

	public SpiderNest() {
		
		hp(ht(10));
		defenseSkill = 1;
		baseSpeed = 0f;

		exp = 0;
		maxLvl = 9;
		
		postpone(20);
		
		loot = new PotionOfHealing();
		lootChance = 0.2f;

		movable = false;
	}
	
	@Override
	public int damageRoll() {
		return 0;
	}
	
	@Override
	public int attackSkill( Char target ) {
		return 0;
	}
	
	@Override
	protected boolean act(){
		super.act();

<<<<<<< HEAD:RemixedDungeon/src/main/java/com/nyrds/pixeldungeon/mobs/spiders/SpiderNest.java
		MobSpawner.spawnRandomMob(Dungeon.level, this);

		setState(SLEEPING);
=======
		Mob newSpider = MobSpawner.spawnRandomMob(Dungeon.level, getPos());
		
		if(isPet()) {
			Mob.makePet(newSpider, Dungeon.hero);
		}
		setState(MobAi.getStateByClass(Sleeping.class));
>>>>>>> Separate AiState from Mob - WiP:PixelDungeon/src/main/java/com/nyrds/pixeldungeon/mobs/spiders/SpiderNest.java
		
		postpone(20);
		
		return true;
	}
	
	@Override
	public int dr() {
		return 0;
	}

	@Override
	public boolean canBePet() {
		return false;
	}
}
