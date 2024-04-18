::MSU.MH.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	q.m.MSU_PreviewSkill <- null;
	q.m.MSU_PreviewMovement <- null;

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
		if (::MSU.Mod.ModSettings.getSetting("ExpandedSkillTooltips").getValue())
		{
			local activeEntity = this.getActiveEntity();
			if (activeEntity != null)
			{
				local skillID = "SkillID" in _costsPreview ? _costsPreview.SkillID : "";
				local skill;
				local movement;
				if (skillID == "")
				{
					movement = ::Tactical.getNavigator().getCostForPath(activeEntity, ::Tactical.getNavigator().getLastSettings(), activeEntity.getActionPoints(), activeEntity.getFatigueMax() - activeEntity.getFatigue());
				}
				else skill = activeEntity.getSkills().getSkillByID(skillID);

				activeEntity.getSkills().m.IsPreviewing = true;
				this.m.MSU_PreviewSkill = skill;
				this.m.MSU_PreviewMovement = movement;
				activeEntity.getSkills().onAffordablePreview(skill, movement == null ? null : movement.End);
				activeEntity.getSkills().updatePreview(skill, movement);
			}
		}

		this.m.MSU_JSHandle.__JSHandle = this.m.JSHandle;
		this.m.JSHandle = this.m.MSU_JSHandle;
		__original(_costsPreview);
		this.m.JSHandle = this.m.MSU_JSHandle.__JSHandle;
		this.m.JSHandle.asyncCall("updateCostsPreview", this.m.ActiveEntityCostsPreview);
		local activeEntity = this.getActiveEntity();
		if (activeEntity != null)
			activeEntity.getSkills().update();
	}

	q.resetActiveEntityCostsPreview = @(__original) function()
	{
		local activeEntity = this.getActiveEntity();
		if (activeEntity != null)
		{
			activeEntity.getSkills().m.IsPreviewing = false;
			this.m.MSU_PreviewSkill = null;
			this.m.MSU_PreviewMovement = null;
		}
		__original();
	}
});
