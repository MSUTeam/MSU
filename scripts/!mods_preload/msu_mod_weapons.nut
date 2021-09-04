local gt = this.getroottable();

gt.MSU.modWeapons <- function ()
{
	# The following hooks are unfortunately necessary because some vanilla
	# weapons used by the AI have no Categories defined for them and hence
	# receive no automatic WeaponType.
	
	::mods_hookNewObject("items/tools/faction_banner", function(o) {
		o.setWeaponType(this.Const.Items.WeaponType.Polearm);
	});

	::mods_hookNewObject("items/weapons/barbarians/drum_item", function(o) {
		o.addWeaponType(this.Const.Items.WeaponType.Musical, false);
		o.addWeaponType(this.Const.Items.WeaponType.Mace);
	});
}