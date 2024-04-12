::MSU.MH.hook("scripts/items/weapons/barbarians/drum_item", function(q) {
	q.create = @(__original) function() {
		__original()
		this.addWeaponType(::Const.Items.WeaponType.Musical, false);
		this.addWeaponType(::Const.Items.WeaponType.Mace);
	}
});
