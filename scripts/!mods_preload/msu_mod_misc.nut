local gt = this.getroottable();

gt.MSU.modMisc <- function ()
{
	::mods_hookExactClass("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(o) {
		o.isActiveEntity <- function( _entity )
		{
			local activeEntity = this.getActiveEntity();
			return activeEntity != null && activeEntity.getID() == _entity.getID();
		}
	});

	local old_assignTroops = gt.Const.World.Common.assignTroops;
	gt.Const.World.Common.assignTroops <- function( _party, _partyList, _resources, _weightMode = 1)
	{
		local p = old_assignTroops( _party, _partyList, _resources, _weightMode);
		_party.setBaseMovementSpeedMult(p.MovementSpeedMult);
		_party.resetBaseMovementSpeed();
		return p;
	}
}
