local gt = this.getroottable();

gt.Const.MSU.modSkill <- function ()
{	
	::mods_hookBaseClass("skills/skill", function(o) {
		o = o[o.SuperName];
		
		o.m.IsBaseValuesSaved <- false;
		o.m.ScheduledChanges <- [];
		
		o.hasPiercingDamage <- function(_only = false)
		{
			switch(this.m.InjuriesOnBody)
			{
				case this.Const.Injury.PiercingBody:
					return true;
					
				case this.Const.Injury.CuttingAndPiercingBody:
				case this.Const.Injury.BluntAndPiercingBody:
				case this.Const.Injury.BurningAndPiercingBody:
					return _only ? false : true;
			}
			
			return false;
		}
		
		o.hasCuttingDamage <- function(_only = false)
		{	
			switch(this.m.InjuriesOnBody)
			{
				case this.Const.Injury.CuttingBody:
					return true;
					
				case this.Const.Injury.CuttingAndPiercingBody:
					return _only ? false : true;
			}
			
			return false;
		}
		
		o.hasBluntDamage <- function(_only = false)
		{
			switch(this.m.InjuriesOnBody)
			{
				case this.Const.Injury.BluntBody:
					return true;
					
				case this.Const.Injury.BluntAndPiercingBody:
					return _only ? false : true;
			}
			
			return false;
		}
		
		o.hasBurningDamage <- function(_only = false)
		{
			switch(this.m.InjuriesOnBody)
			{
				case this.Const.Injury.BurningBody:
					return true;
					
				case this.Const.Injury.BurningAndPiercingBody:
					return _only ? false : true;
			}
			
			return false;
		}
		
		o.m.scheduleChange <- function( _field, _change, _set = true )
		{
			this.ScheduledChanges.push({Field = _field, Change = _change, Set = _set});			
		}
		
		o.m.executeScheduledChanges <- function()
		{
			if (this.ScheduledChanges.len() == 0)
			{
				return;
			}
			
			foreach (c in this.ScheduledChanges)
			{
				switch (typeof c.Change)
				{
					case "integer":
						if (c.Set)
						{
							this[c.Field] = c.Change;
						}
						else
						{
							this[c.Field] += c.Change;
						}
						
						break;
					
					case "string":
						if (c.Set)
						{
							this[c.Field] = c.Change;
						}
						else
						{
							this[c.Field] += c.Change;
						}
						break;
						
					default:
						this[c.Field] = c.Change;
						break;
				}
			}
			
			this.ScheduledChanges.clear();
		}
		
		o.saveBaseValues <- function()
		{
			if (this.m.IsBaseValuesSaved)
			{
				return;
			}
			
			this.m.b <- clone this.skill.m;			
			this.m.IsBaseValuesSaved = true;
		}
		
		o.m.softReset <- function()
		{
			if (!this.IsBaseValuesSaved)
			{
				this.logWarning("MSU Mod softReset() skill \"" + this.ID + "\" does not have base values saved.");
				return false;
			}
			
			this.ActionPointCost = this.b.ActionPointCost;
			this.FatigueCost = this.b.FatigueCost;
			this.FatigueCostMult = this.b.FatigueCostMult;		
			this.MinRange = this.b.MinRange;
			this.MaxRange = this.b.MaxRange;
						
			return true;
		}
		
		o.m.hardReset <- function()
		{
			if (!this.IsBaseValuesSaved)
			{
				this.logWarning("MSU Mod hardReset() skill \"" + this.ID + "\" does not have base values saved.");
				return false;
			}
				
			foreach (k, v in this.b)
			{
				this[k] = v;
			}
			
			return true;
		}
		
		o.m.resetField <- function( _field )
		{
			if (!this.IsBaseValuesSaved)
			{
				this.logWarning("MSU Mod resetField() skill \"" + this.ID + "\" does not have base values saved.");
				return false;
			}
			
			this[_field] = this.b[_field];
			
			return true;
		}
		
		o.onMovementStarted <- function( _tile, _numTiles )
		{
		}
		
		o.onMovementFinished <- function( _tile )
		{
		}
		
		o.onAfterDamageReceived <- function()
		{
		}
		
		o.onAnySkillExecuted <- function(_skill, _targetTile)
		{
		}
		
		o.onBeforeAnySkillExecuted <- function(_skill, _targetTile)
		{
		}
		
		local use = o.use;
		o.use = function( _targetTile, _forFree = false )
		{
			# Save the container as a local variable because some skills delete
			# themselves during use (e.g. Reload Bolt) causing this.m.Container
			# to point to null.
			local container = this.m.Container;
			
			container.onBeforeAnySkillExecuted(this, _targetTile);

			local ret = use( _targetTile, _forFree );
			
			container.onAnySkillExecuted(this, _targetTile);
			
			return ret;
		}
	});
}
