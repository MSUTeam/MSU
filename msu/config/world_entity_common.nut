local assignTroops = ::Const.World.Common.assignTroops;
::Const.World.Common.assignTroops <- function( _party, _partyList, _resources, _weightMode = 1 )
{
	local p = assignTroops(_party, _partyList, _resources, _weightMode);
	_party.setBaseMovementSpeedMult(p.MovementSpeedMult);
	_party.resetBaseMovementSpeed();
	return p;
}
