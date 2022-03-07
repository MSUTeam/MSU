::mods_hookExactClass("skills/items/generic_item", function(o) {
	o.onAfterUpdate <- function( _properties )
	{
		if (this.m.Item != null)
		{
			if (typeof this.m.Item == "instance")
			{
				this.m.Item = this.m.Item.get();
			}
			this.m.Item.onAfterUpdateProperties(_properties);
		}
		else
		{
			this.removeSelf();
		}
	}
});