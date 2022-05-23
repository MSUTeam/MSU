::mods_hookChildren("states/state", function(o) {
	local onInit = o.onInit;
	o.onInit = function()
	{
		::MSU.Utils.States[this.ClassName] <- ::WeakTableRef(this);
		return onInit();
	}
});
