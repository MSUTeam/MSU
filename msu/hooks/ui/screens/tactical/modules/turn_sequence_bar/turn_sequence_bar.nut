::MSU.MH.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	q.isActiveEntity <- function( _entity )
	{
		local activeEntity = this.getActiveEntity();
		return activeEntity != null && activeEntity.getID() == _entity.getID();
	}

	q.setActiveEntityCostsPreview = @(__original) function( _costsPreview )
	{
		if (::MSU.Mod.ModSettings.getSetting("ExpandedSkillTooltips").getValue())
		{
			local activeEntity = this.getActiveEntity();
			if (activeEntity != null)
			{
				local skillID = "SkillID" in _costsPreview ? _costsPreview.SkillID : "";
				local skill;
				local movementTile;
				if (skillID == "")
				{
					local movement = ::Tactical.getNavigator().getCostForPath(activeEntity, ::Tactical.getNavigator().getLastSettings(), activeEntity.getActionPoints(), activeEntity.getFatigueMax() - activeEntity.getFatigue());
					movementTile = movement.End;
				}
				else skill = activeEntity.getSkills().getSkillByID(skillID);

				activeEntity.getSkills().m.IsPreviewing = true;
				activeEntity.getSkills().onAffordablePreview(skill, movementTile);
			}
		}

		__original(_costsPreview);
	}

	q.resetActiveEntityCostsPreview = @(__original) function()
	{
		local activeEntity = this.getActiveEntity();
		if (activeEntity != null) activeEntity.getSkills().m.IsPreviewing = false;
		__original();
	}
});
