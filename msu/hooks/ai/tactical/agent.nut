::mods_hookNewObject("ai/tactical/agent", function(o) {
	o.think = function( _evaluateOnly = false )
	{
		if (!this.m.Actor.isAlive() || !this.m.IsTurnStarted || this.m.IsFinished || ::Tactical.CameraDirector.isDelayed())
		{
			return;
		}

		if (::Settings.getGameplaySettings().AlwaysFocusCamera && !this.m.Actor.isPlayerControlled() && !this.m.Actor.isHiddenToPlayer())
		{
			::Tactical.getCamera().moveToExactly(this.m.Actor);
		}		

		if (this.m.IsEvaluating)
		{
			if (::Tactical.getNavigator().IsTravelling || this.getActor().getSkills().m.IsExecutingMoveSkill)
			{
				return;
			}

			if (::Const.AI.PathfindingDebugMode)
			{
				::Tactical.getNavigator().clearPath();
			}

			if (this.m.NextEvaluationTime <= this.Time.getVirtualTime())
			{
				this.evaluate(this.m.Actor);
			}
		}

		if (!_evaluateOnly && (this.isReady() || this.m.ActiveBehavior != null && this.m.ActiveBehavior.getID() == ::Const.AI.Behavior.ID.Idle && this.m.Actor.getActionPoints() == this.m.Actor.getActionPointsMax() || !::Tactical.TurnSequenceBar.isLastEntityPlayerControlled() && this.m.ActiveBehavior != null && this.m.ActiveBehavior.getID() == ::Const.AI.Behavior.ID.Idle && !::Tactical.getNavigator().IsTravelling && (::Const.Tactical.Common.LastAIBehaviorID == ::Const.AI.Behavior.ID.EngageMelee || ::Const.Tactical.Common.LastAIBehaviorID == ::Const.AI.Behavior.ID.EngageRanged)))
		{
			this.m.IsEvaluating = this.execute(this.m.Actor);

			if (this.m.IsEvaluating)
			{
				this.m.ActiveBehavior = null;
			}
		}

		if (!this.m.Actor.isAlive())
		{
			this.setFinished(true);
		}
	}
});
