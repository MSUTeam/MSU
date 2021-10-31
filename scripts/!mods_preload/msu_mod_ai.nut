local gt = this.getroottable();

gt.MSU.modAI <- function() 
{
	::mods_hookNewObject("ai/tactical/agent", function(o) {
		o.think = function( _evaluateOnly = false )
		{
			if (!this.m.Actor.isAlive() || !this.m.IsTurnStarted || this.m.IsFinished || this.Tactical.CameraDirector.isDelayed())
			{
				return;
			}

			if (this.Settings.getGameplaySettings().AlwaysFocusCamera && !this.m.Actor.isPlayerControlled() && !this.m.Actor.isHiddenToPlayer())
			{
				this.Tactical.getCamera().moveToExactly(this.m.Actor);
			}		

			if (this.m.IsEvaluating)
			{
				if (this.Tactical.getNavigator().IsTravelling || this.getActor().getSkills().m.IsExecutingMoveSkill)
				{
					return;
				}

				if (this.Const.AI.PathfindingDebugMode)
				{
					this.Tactical.getNavigator().clearPath();
				}

				if (this.m.NextEvaluationTime <= this.Time.getVirtualTime())
				{
					this.evaluate(this.m.Actor);
				}
			}

			if (!_evaluateOnly && (this.isReady() || this.m.ActiveBehavior != null && this.m.ActiveBehavior.getID() == this.Const.AI.Behavior.ID.Idle && this.m.Actor.getActionPoints() == this.m.Actor.getActionPointsMax() || !this.Tactical.TurnSequenceBar.isLastEntityPlayerControlled() && this.m.ActiveBehavior != null && this.m.ActiveBehavior.getID() == this.Const.AI.Behavior.ID.Idle && !this.Tactical.getNavigator().IsTravelling && (this.Const.Tactical.Common.LastAIBehaviorID == this.Const.AI.Behavior.ID.EngageMelee || this.Const.Tactical.Common.LastAIBehaviorID == this.Const.AI.Behavior.ID.EngageRanged)))
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

		local onTurnStarted = o.onTurnStarted;
		o.onTurnStarted = function ()
		{
			onTurnStarted();
			this.getActor().getSkills().m.IsExecutingMoveSkill = false;
		}

		local onTurnResumed = o.onTurnResumed;
		o.onTurnResumed = function () 
		{
			onTurnResumed();
			this.getActor().getSkills().m.IsExecutingMoveSkill = false;
		}

		local onTurnEnd = o.onTurnEnd;
		o.onTurnEnd = function () 
		{
			onTurnEnd();
			this.getActor().getSkills().m.IsExecutingMoveSkill = false;
		}
	});
}
