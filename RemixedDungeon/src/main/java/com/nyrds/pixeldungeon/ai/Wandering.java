package com.nyrds.pixeldungeon.ai;

import com.nyrds.pixeldungeon.ml.R;
import com.watabou.noosa.Game;
import com.watabou.pixeldungeon.actors.Actor;
import com.watabou.pixeldungeon.actors.Char;
import com.watabou.pixeldungeon.actors.mobs.Mob;
import com.watabou.pixeldungeon.utils.Utils;
import com.watabou.utils.Random;

public class Wandering extends MobAi implements AiState {

    public Wandering(){ }

    @Override
    public boolean act(Mob me) {

        Char enemy = chooseEnemy(me);
        me.setEnemy(enemy);

        if (me.isEnemyInFov()
                && ( Random.Int(me.distance(me.getEnemy()) / 2
                + me.getEnemy().stealth()) == 0)) {
            huntEnemy(me);
        } else {

            me.enemySeen = false;

            int oldPos = me.getPos();

            if (me.level().cellValid(me.target) && me.getCloser(me.target)) {
                me.spend(1 / me.speed());
                return me.moveSprite(oldPos, me.getPos());
            } else {
                me.target = me.level().randomDestination();
                me.spend(Actor.TICK);
            }

        }
        return true;
    }

    @Override
    public String status(Mob me) {
        return Utils.format(Game.getVar(R.string.Mob_StaWanderingStatus),
                me.getName());
    }

    @Override
    public void gotDamage(Mob me,Object src, int dmg) {
        seekRevenge(me,src);
    }
}
