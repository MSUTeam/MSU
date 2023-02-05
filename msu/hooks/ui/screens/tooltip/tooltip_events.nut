::mods_hookNewObjectOnce("ui/screens/tooltip/tooltip_events", function(o) {
	o.general_querySkillNestedTooltipData <- function( _entityId, _skillId, _filename )
	{
		if (_skillId == null) _skillId = ::MSU.NestedTooltips.SkillObjectsByFilename[_filename].getID();
		local entity = _entityId != null ? ::Tactical.getEntityByID(_entityId) : null;
		local skill;
		if (entity != null)
		{
			skill = entity.getSkills().getSkillByID(_skillId);
		}

		if (skill == null)
		{
			skill = ::MSU.NestedTooltips.SkillObjectsByFilename[_filename];
			skill.m.Container = ::Reforged.getDummyPlayer().getSkills();
			local ret = skill.getNestedTooltip();
			skill.m.Container = null;
			return ret;
		}

		return skill.getNestedTooltip();
	}

	local tactical_queryTileTooltipData = o.tactical_queryTileTooltipData;
	o.tactical_queryTileTooltipData = function()
	{
		local ret = tactical_queryTileTooltipData();
		if (ret != null && ::Tactical.TurnSequenceBar.getActiveEntity() != null && ::Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled())
		{
			::Tactical.TurnSequenceBar.getActiveEntity().getSkills().onQueryTileTooltip(::Tactical.State.getLastTileHovered(), ret);
		}
		return ret;
	}

	local general_querySkillTooltipData = o.general_querySkillTooltipData;
	o.general_querySkillTooltipData = function( _entityId, _skillId )
	{
		local ret = general_querySkillTooltipData(_entityId, _skillId);

		if (ret != null)
		{
			local skill = ::Tactical.getEntityByID(_entityId).getSkills().getSkillByID(_skillId);
			skill.getContainer().onQueryTooltip(skill, ret);
		}

		return ret;
	}

	local general_queryStatusEffectTooltipData = o.general_queryStatusEffectTooltipData;
	o.general_queryStatusEffectTooltipData = function( _entityId, _statusEffectId )
	{
		local ret = general_queryStatusEffectTooltipData(_entityId, _statusEffectId);
		if (ret != null)
		{
			local statusEffect = ::Tactical.getEntityByID(_entityId).getSkills().getSkillByID(_statusEffectId);
			statusEffect.getContainer().onQueryTooltip(statusEffect, ret);
		}

		return ret;
	}

	o.onQueryMSUTooltipData <- function( _data )
	{
		local ret = ::MSU.System.Tooltips.getTooltip(_data.modId, _data.elementId);
		_data.ExtraData <- ret.Data;
		return ret.Tooltip.getUIData(_data);
	}

	local general_queryUIElementTooltipData = o.general_queryUIElementTooltipData;
	// deprecated, MSU settings (and future tooltips) should now use onQueryMSUTooltipData
	o.general_queryUIElementTooltipData = function( _entityId, _elementId, _elementOwner )
	{
		local ret = general_queryUIElementTooltipData(_entityId, _elementId, _elementOwner);
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
