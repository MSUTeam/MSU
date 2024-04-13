::MSU.MH.hook("scripts/items/tools/faction_banner", function(q) {
	q.create = @(__original) function() {
		__original();
		this.setWeaponType(::Const.Items.WeaponType.Polearm);
	}
});
