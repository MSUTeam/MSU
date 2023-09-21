::MSU.HooksMod.hook("scripts/states/state", function(q) {
	q.onInit = @(__original) function()
	{
		::MSU.Utils.States[this.ClassName] <- ::WeakTableRef(this);
		return __original();
	}
});
