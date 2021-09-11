local gt = this.getroottable();

gt.MSU.modSkillContainer <- function ()
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

		o.doOnFunction <- function( _function, _argsArray = null, aliveOnly = false )
		{
			if (_argsArray == null)
			{
				_argsArray = [];
			}

			_argsArray.insert(0, null);
			this.m.IsUpdating = true;
			this.m.IsBusy = false;
			this.m.BusyStack = 0;

			foreach( skill in this.m.Skills )
			{
				if (aliveOnly && !this.m.Actor.isAlive())
				{
					break;
				}

				if (!skill.isGarbage())
				{
					_argsArray[0] = skill;
					skill[_function].acall(_argsArray);
				}
			}

			this.m.IsUpdating = false;
			this.update();
		}

		o.doOnFunctionWhenAlive <- function( _function, _argsArray = null )
		{
			this.doOnFunction(_function, _argsArray, true);
		}

		local onAfterDamageReceived = o.onAfterDamageReceived;
		o.onAfterDamageReceived = function()
		{
			this.doOnFunctionWhenAlive("onAfterDamageReceived");

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

		o.onAnySkillExecuted <- function( _skill, _targetTile, _targetEntity )
		{
			this.doOnFunction("onAnySkillExecuted", [
				_skill,
				_targetTile,
				_targetEntity
			]);
		}

		o.onBeforeAnySkillExecuted <- function( _skill, _targetTile, _targetEntity )
		{
			this.doOnFunction("onBeforeAnySkillExecuted", [
				_skill,
				_targetTile,
				_targetEntity
			]);
		}

		o.onNewMorning <- function()
		{
			this.doOnFunctionWhenAlive("onNewMorning");
		}
		
		o.getItemActionCost <- function( _items )
		{
			local info = [];
			foreach (skill in this.m.Skills)
			{
				local cost = skill.getItemActionCost(_items);
				if (cost != null)
				{
					info.push({Skill = skill, Cost = cost});
				}
			}

			return info;
		}

		o.onPayForItemAction <- function( _skill, _items )
		{
			this.doOnFunction("onPayForItemAction", [
				_skill,
				_items
			]);
		}

		o.getSkillsByFunction <- function( _self, _function )
		{
			local ret = [];
			foreach (skill in this.m.Skills)
			{
				if (!skill.isGarbage() && _function.call(_self, skill))
				{
					ret.push(skill);
				}
			}

			return ret;
		}
	});
}
