::MSU.NestedTooltips <- {
	SkillObjectsByFilename = {},
	ItemObjectsByFilename = {},
	PerkIDByFilename = {}
};

::MSU.AfterQueue.add(::MSU.ID, function() {
	foreach (file in ::IO.enumerateFiles("scripts/skills"))
	{
		local skill = ::new(file);
		if (::MSU.isIn("saveBaseValues", skill, true))
		{
			skill.saveBaseValues();
			::MSU.NestedTooltips.SkillObjectsByFilename[split(file, "/").top()] <- skill;
		}
	}

	foreach (file in ::IO.enumerateFiles("scripts/items"))
	{
		local item = ::new(file);
		if (::MSU.isIn("getID", item, true))
		{
			::MSU.NestedTooltips.ItemObjectsByFilename[split(file, "/").top()] <- item;
		}
	}
});
