::MSU.MH.hook("scripts/items/item", function(q) {
	q.isItemType = @() function( _t, _any = true, _only = false )
	{
		if (_t == 0 || this.m.ItemType == 0)
		{
			return _t == 0;
		}

		if (_any)
		{
			return _only ? this.m.ItemType - (this.m.ItemType & _t) == 0 : (this.m.ItemType & _t) != 0;
		}
		else
		{
			return _only ? (this.m.ItemType & _t) == this.m.ItemType : (this.m.ItemType & _t) == _t;
		}
	}

	q.addItemType <- function ( _t )
	{
		this.m.ItemType = this.m.ItemType | _t;
	}

	q.setItemType <- function( _t )
	{
		this.m.ItemType = _t;
	}

	q.removeItemType <- function( _t )
	{
		if (this.isItemType(_t, false)) this.m.ItemType -= _t;
		else throw ::MSU.Exception.KeyNotFound(_t);
	}

	q.getSkills <- function()
	{
		return this.m.SkillPtrs.filter(@(idx, skill) skill.getID() != "items.generic");
	}

	q.getMovementSpeedMult <- function()
	{
		return 1.0;
	}

	q.getDescription = @(__original) function()
	{
		if (!::MSU.Mod.ModSettings.getSetting("ExpandedItemTooltips").getValue())
		{
			return __original();
		}

		local names = "";
		foreach (itemType in ::Const.Items.ItemType)
		{
			if (this.isItemType(itemType))
			{
				local name = ::Const.Items.getItemTypeName(itemType);
				if (name != "")
				{
					names += name + ", "
				}
			}
		}

		return names != "" ? "[color=" + ::Const.UI.Color.NegativeValue + "]" + names.slice(0, -2) + "[/color]\n\n" + __original() : __original();
	}

	// VanillaFix: https://steamcommunity.com/app/365360/discussions/1/604159344068529469/
	// SkillPtrs having skills which have been removed from skill_container.
	// In vanilla clearSkills() calls container.remove(skill) on each skill in SkillPtrs
	// which triggers an immediate removal and skill_container.update on each iteration.
	// This leads to the issue if someone accesses this item's skills during skill.onUpdate
	// it will provide skills which have already been removed from the container leading
	// to an error when you try skill.getContainer().something.
	q.clearSkills = @() function()
	{
		if (this.getContainer() == null || this.getContainer().getActor() == null || this.getContainer().getActor().isNull())
		{
			return;
		}

		// Instead of vanilla style of .remove(skill) we just set the skill to garbage
		// and then collect garbage after SkillPtrs have been cleared so that the
		// skill_container.update happens after the SkillPtrs are properly empty.
		foreach (skill in this.m.SkillPtrs)
		{
			skill.removeSelf();
		}

		this.m.SkillPtrs = [];

		this.getContainer().getActor().getSkills().collectGarbage();
	}

	q.onAfterUpdateProperties <- function( _properties )
	{			
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
	}
});
