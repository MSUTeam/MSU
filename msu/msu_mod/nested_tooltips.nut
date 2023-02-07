::MSU.NestedTooltips <- {
	SkillObjectsByFilename = {}
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
});
