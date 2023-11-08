::MSU.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
	q.general_querySkillNestedTooltipData <- function( _entityId, _skillId, _filename )
	{
		if (_skillId == null) _skillId = ::MSU.NestedTooltips.SkillObjectsByFilename[_filename].getID();
		local entity = _entityId != null ? ::Tactical.getEntityByID(_entityId) : null;
		local skill;
		if (entity != null)
		{
			skill = entity.getSkills().getSkillByID(_skillId);
		}

		if (skill != null)
			return skill.getNestedTooltip();

		local ret;
		if (::MSU.isNull(::MSU.NestedTooltips.NestedSkillItem))
		{
			skill = ::MSU.NestedTooltips.SkillObjectsByFilename[_filename];
			skill.m.Container = ::MSU.getDummyPlayer().getSkills();
			ret = skill.getNestedTooltip();
			skill.m.Container = null;
			return ret;
		}

		local item = ::MSU.NestedTooltips.NestedSkillItem;
		local isDummyEquipping = ::MSU.isNull(item.getContainer());

		if (isDummyEquipping) ::MSU.getDummyPlayer().getItems().equip(item);
		foreach (s in item.getSkills())
		{
			if (s.getID() == _skillId)
			{
				ret = s.getNestedTooltip();
				break;
			}
		}
		if (isDummyEquipping) ::MSU.getDummyPlayer().getItems().unequip(item);

		return ret;
	}

	q.general_queryItemNestedTooltipData <- function( _entityId, _itemId, _itemOwner, _filename )
	{
		local item;

		if (_itemId != null)
		{
			local entity = _entityId != null ? ::Tactical.getEntityByID(_entityId) : null;
			switch (_itemOwner)
			{
				case "entity":
					if (entity != null) item = entity.getItems().getItemByInstanceID(_itemId);
					break;

				case "ground":
				case "character-screen-inventory-list-module.ground":
					if (entity != null) item = ::TooltipEvents.tactical_helper_findGroundItem(entity, _itemId);
					break;

				case "stash":
				case "character-screen-inventory-list-module.stash":
					local result = ::Stash.getItemByInstanceID(_itemId);
					if (result != null) item = result.item;
					break;

				case "craft":
					return ::World.Crafting.getBlueprint(_itemId).getTooltip();

				case "blueprint":
					return ::World.Crafting.getBlueprint(_entityId).getTooltipForComponent(_itemId);

				case "world-town-screen-shop-dialog-module.stash":
					local result = ::Stash.getItemByInstanceID(_itemId);
					if (result != null) item = result.item;
					break;

				case "world-town-screen-shop-dialog-module.shop":
					local stash = ::World.State.getTownScreen().getShopDialogModule().getShop().getStash();
					if (stash != null)
					{
						local result = stash.getItemByInstanceID(_itemId);
						if (result != null) item = result.item;
					}
					break;

				case "tactical-combat-result-screen.stash":
					local result = ::Stash.getItemByInstanceID(_itemId);
					if (result != null) item = result.item;
					break;

				case "tactical-combat-result-screen.found-loot":
					local result = ::Tactical.CombatResultLoot.getItemByInstanceID(_itemId);
					if (result != null) item = result.item;
					break;
			}
		}
		else
		{
			item = ::MSU.NestedTooltips.ItemObjectsByFilename[_filename];
		}

		return item.getNestedTooltip();
	}
	
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
		local ret = ::MSU.System.Tooltips.getTooltip(_data.modId, _data.elementId);
		_data.ExtraData <- ret.Data;
		return ret.Tooltip.getUIData(_data);
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
