::mods_hookNewObject("entity/tactical/tactical_entity_manager", function(o) {
	o.getActorsByFunction <- function( _function )
	{
		local ret = [];
		foreach (actor in this.getAllInstancesAsArray())
		{
			if (_function(actor)) ret.push(actor);
		}		
		return ret;
	}
	
	o.getAlliedActors <- function( _faction, _tile = null, _distance = null, _atDistance = false )
	{
		return this.getActorsByFunction(function(_actor) {
			if (!_actor.isAlliedWith(_faction)) return false;
			if (_tile != null)
			{
				local distance = _tile.getDistanceTo(_actor.getTile());
				if (distance > _distance || (_atDistance && distance != _distance)) return false;
			}
			return true;
		});
	}
	
	o.getHostileActors <- function( _faction, _tile = null, _distance = null, _atDistance = false )
	{
		return this.getActorsByFunction(function(_actor) {
			if (_actor.isAlliedWith(_faction)) return false;
			if (_tile != null)
			{
				local distance = _tile.getDistanceTo(_actor.getTile());
				if (distance > _distance || (_atDistance && distance != _distance)) return false;
			}
			return true;
		});
	}
	
	o.getFactionActors <- function( _faction, _tile = null, _distance = null, _atDistance = false )
	{
		if (_tile == null) return clone this.getInstancesOfFaction(_faction);
				
		local actors = this.getInstancesOfFaction(_faction);
		local ret = [];
		foreach (actor in actors)
		{
			local distance = _tile.getDistanceTo(actor.getTile());
			if (distance > _distance || (_atDistance && distance != _distance)) continue;
			ret.push(actor);			
		}
		return ret;
	}
	
	o.getNonFactionAlliedActors <- function( _faction, _tile = null, _distance = null, _atDistance = false )
	{
		return this.getActorsByFunction(function(_actor) {
			if (!_actor.isAlliedWith(_faction) || _actor.getFaction() == _faction) return false;
			if (_tile != null)
			{
				local distance = _tile.getDistanceTo(_actor.getTile());
				if (distance > _distance || (_atDistance && distance != _distance)) return false;
			}
			return true;
		});
	}
});
