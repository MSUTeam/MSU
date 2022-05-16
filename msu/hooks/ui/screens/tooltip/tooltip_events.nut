::mods_hookNewObjectOnce("ui/screens/tooltip/tooltip_events", function(o) {
	local general_querySkillTooltipData = o.general_querySkillTooltipData;
	o.general_querySkillTooltipData = function( _entityId, _skillId )
	{
		local entity = ::Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			local skill = entity.getSkills().getSkillByID(_skillId);

			if (skill != null)
			{
				local tooltip = skill.getTooltip();
				skill.getContainer().onQueryTooltip(skill, tooltip);
				return tooltip;
			}
		}

		return null;
	}

	local general_queryStatusEffectTooltipData = o.general_queryStatusEffectTooltipData;
	o.general_queryStatusEffectTooltipData = function( _entityId, _statusEffectId )
	{
		local entity = ::Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			local statusEffect = entity.getSkills().getSkillByID(_statusEffectId);

			if (statusEffect != null)
			{	
				local tooltip = statusEffect.getTooltip();
				statusEffect.getContainer().onQueryTooltip(statusEffect, tooltip);
				return tooltip;
			}
		}

		return null;
	}

	local general_queryUIElementTooltipData = o.general_queryUIElementTooltipData;
	o.general_queryUIElementTooltipData = function( _entityId, _elementId, _elementOwner )
	{
		local ret = general_queryUIElementTooltipData(_entityId, _elementId, _elementOwner);
		if (ret == null)
		{
			if (_elementId.find(::MSU.TooltipIdentifiers.SettingsIdentifier) == 0)
			{
				local threePartArray = split(_elementId, ".")
				local setting = ::getModSetting(threePartArray[1], threePartArray[2]);
				return [
					{
						id = 1,
						type = "title",
						text = setting.getName()
					},
					{
						id = 2,
						type = "description",
						text = setting.getDescription()
					}
				];
			}
			else if (_elementId.find(::MSU.TooltipIdentifiers.GeneralIdentifier) == 0)
			{
				local fullKey = split(_elementId, ".");
				fullKey = fullKey.slice(1, fullKey.len());
				local currentKey;
				local currentTable = MSU.TooltipIdentifiers;
				while (fullKey.len() > 0)
				{
					currentKey = fullKey.remove(0);
					if (!(currentKey in currentTable))
					{
						::MSU.Mod.Debug.printWarning("Key : " + currentKey + " is not a valid tooltip identifier!", "tooltip");
						return ret;
					}
					currentTable = currentTable[currentKey];
				}
				this.logInfo(currentTable.Title)
				this.logInfo(currentTable.Description)
				return [
					{
						id = 1,
						type = "title",
						text = currentTable.Title
					},
					{
						id = 2,
						type = "description",
						text = currentTable.Description
					}
				];
			}
		}
		return ret;
		
	}
});
