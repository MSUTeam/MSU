local gt = this.getroottable();

gt.Const.MSU.modSkillContainer <- function ()
{
	::mods_hookNewObject("skills/skill_container", function(o) {
		local update = o.update;
		o.update = function()
		{
			if (this.m.IsUpdating || !this.m.Actor.isAlive())
			{
				return;
			}

			foreach( skill in this.m.Skills )
			{
				skill.saveBaseValues();
				skill.softReset();
			}

			update();

			foreach( skill in this.m.Skills )
			{
				skill.executeScheduledChanges();
			}
		}

		local onAfterDamageReceived = o.onAfterDamageReceived;
		o.onAfterDamageReceived = function()
		{
			this.doOnFunction("onAfterDamageReceived");

			onAfterDamageReceived();
		}

		o.onMovementStarted <- function( _tile, _numTiles )
		{
			this.doOnFunction("onMovementStarted", [
				_tile,
				_numTiles
			]);
		}

		o.onMovementFinished <- function( _tile )
		{
			this.doOnFunction("onMovementFinished", [
				_tile
			]);
		}

		o.onAnySkillExecuted <- function(_skill, _targetTile)
		{
			this.doOnFunction("onAnySkillExecuted", [
				_skill,
				_targetTile
			]);
		}

		o.onBeforeAnySkillExecuted <- function(_skill, _targetTile)
		{
			this.doOnFunction("onBeforeAnySkillExecuted", [
				_skill,
				_targetTile
			]);
		}
	});
}
