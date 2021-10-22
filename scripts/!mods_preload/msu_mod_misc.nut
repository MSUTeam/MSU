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
}
