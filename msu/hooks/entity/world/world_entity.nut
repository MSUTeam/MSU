::mods_hookBaseClass("entity/world/world_entity", function (o)
{
	o = o[o.SuperName];

	// VANILLAFIX https://steamcommunity.com/app/365360/discussions/1/5350867208707944706/
	o.isAbleToSee = function( _entity )
	{
		local e = typeof _entity == "instance" ? _entity.get() : _entity;
		return e.isVisibleToEntity(this, this.getVisionRadius());
	}
});
