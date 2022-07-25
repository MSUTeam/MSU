::mods_hookExactClass("skills/items/generic_item", function(o) {
	o.onAfterUpdate <- function( _properties )
	{
		if (!::MSU.isNull(this.m.Item) && !::MSU.isNull(this.m.Item.getContainer()))
		{
			this.m.Item.onAfterUpdateProperties(_properties);
		}
		else
		{
			this.removeSelf();
		}
	}

	o.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (!::MSU.isNull(this.m.Item) && !::MSU.isNull(this.m.Item.getContainer()))
		{
			this.m.Item.onAnySkillUsed(_skill, _targetEntity, _properties);
		}
		else
		{
			this.removeSelf();
		}
	}
});
