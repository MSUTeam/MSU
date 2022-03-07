::mods_hookNewObject("items/weapons/barbarians/drum_item", function(o) {
	o.addWeaponType(this.Const.Items.WeaponType.Musical, false);
	o.addWeaponType(this.Const.Items.WeaponType.Mace);
});