local gt = this.getroottable();

gt.MSU.modTacticalEntityManager <- function ()
{
	::mods_hookNewObject("entity/tactical/tactical_entity_manager", function(o) {
		o.getInstancesAlliedWithFaction <- function( _faction )
		{
			local ret = [];

			foreach (faction in this.m.Instances)
			{
				foreach (actor in faction)
				{
					if (actor.isAlliedWith(_faction))
					{
						ret.extend(faction);
						break;
					}
				}
			}

			return ret;
		}

		o.getInstancesHostileWithFaction <- function( _faction )
		{
			local ret = [];

			foreach (faction in this.m.Instances)
			{
				foreach (actor in faction)
				{
					if (!actor.isAlliedWith(_faction))
					{
						ret.extend(faction);
						break;
					}
				}
			}

			return ret;
		}
	});
}
