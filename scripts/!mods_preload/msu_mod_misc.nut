local gt = this.getroottable();

gt.MSU.modMisc <- function ()
{
	gt.Const.FactionRelation <- {
		Any = 0,
		SameFaction = 1,
		Allied = 2,
		Enemy = 3
	}
	::mods_hookExactClass("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(o) {
		o.isActiveEntity <- function( _entity )
		{
			local activeEntity = this.getActiveEntity();
			return activeEntity != null && activeEntity.getID() == _entity.getID();
		}
	});
}
