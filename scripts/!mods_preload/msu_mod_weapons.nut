local gt = this.getroottable();

gt.MSU.modWeapons <- function ()
{
	::mods_hookNewObject("items/tools/faction_banner", function(o) {
		o.setWeaponType(this.Const.Items.WeaponType.Polearm);
	});

	::mods_hookNewObject("items/weapons/barbarians/drum_item", function(o) {
		o.addWeaponType(this.Const.Items.WeaponType.Musical, false);
		o.addWeaponType(this.Const.Items.WeaponType.Mace);
	});
}