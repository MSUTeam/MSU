::MSU.MH.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.MSU_JSHandle <- {
			__JSHandle = null,
			function asyncCall( _funcName, ... )
			{
				if (_funcName == "updateCostsPreview")
					return;

				vargv.insert(0, _funcName);
				vargv.insert(0, this);
				this.__JSHandle.asyncCall.acall(vargv);
			}
		}
		this.m.MSU_JSHandle.setdelegate({
			function _get( _key )
			{
				if (_key in this.__JSHandle)
					return this.__JSHandle[_key];
				throw null;
			}
		});
	}
	
	q.isActiveEntity <- function( _entity )
	{
		local activeEntity = this.getActiveEntity();
		return activeEntity != null && activeEntity.getID() == _entity.getID();
	}

	q.setActiveEntityCostsPreview = @(__original) function( _costsPreview )
	{
		// The original function also updates the UI, but we don't want to do that yet,
		// we want to do that after our skill container affordability event has run.
		// If we don't switcheroo to disable it here, then we'd need to manually call `updateCostsPreview`
		// on the JSHandle at the end again, and this can lead to slightly glitchy UI animation due to double updating.
		this.m.MSU_JSHandle.__JSHandle = this.m.JSHandle;
		this.m.JSHandle = this.m.MSU_JSHandle;
		__original(_costsPreview);
		this.m.JSHandle = this.m.MSU_JSHandle.__JSHandle;

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

		this.m.JSHandle.asyncCall("updateCostsPreview", this.m.ActiveEntityCostsPreview);
	}

	q.resetActiveEntityCostsPreview = @(__original) function()
	{
		local activeEntity = this.getActiveEntity();
		if (activeEntity != null) activeEntity.getSkills().m.IsPreviewing = false;
		__original();
	}
});
