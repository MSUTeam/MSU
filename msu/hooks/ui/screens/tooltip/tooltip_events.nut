::MSU.MH.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
	q.tactical_queryTileTooltipData = @(__original) function()
	{
		local ret = __original();
		if (ret != null && ::Tactical.TurnSequenceBar.getActiveEntity() != null && ::Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled())
		{
			::Tactical.TurnSequenceBar.getActiveEntity().getSkills().onQueryTileTooltip(::Tactical.State.getLastTileHovered(), ret);
		}
		return ret;
	}

	q.general_querySkillTooltipData = @(__original) function( _entityId, _skillId )
	{
		local ret = __original(_entityId, _skillId);

		if (ret != null)
		{
			local skill = ::Tactical.getEntityByID(_entityId).getSkills().getSkillByID(_skillId);
			skill.getContainer().onQueryTooltip(skill, ret);
		}

		return ret;
	}

	q.general_queryStatusEffectTooltipData = @(__original) function( _entityId, _statusEffectId )
	{
		local ret = __original(_entityId, _statusEffectId);
		if (ret != null)
		{
			local statusEffect = ::Tactical.getEntityByID(_entityId).getSkills().getSkillByID(_statusEffectId);
			statusEffect.getContainer().onQueryTooltip(statusEffect, ret);
		}

		return ret;
	}

	q.onQueryMSUTooltipData <- function( _data )
	{
		return ::MSU.System.Tooltips.getTooltip(_data.modId, _data.elementId).getUIData(_data);
	}

	// deprecated, MSU settings (and future tooltips) should now use onQueryMSUTooltipData
	q.general_queryUIElementTooltipData = @(__original) function( _entityId, _elementId, _elementOwner )
	{
		local ret = __original(_entityId, _elementId, _elementOwner);
		if (ret == null)
		{
			if (_elementId.find("msu-settings") == 0)
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
		}
		return ret;
	}
});
