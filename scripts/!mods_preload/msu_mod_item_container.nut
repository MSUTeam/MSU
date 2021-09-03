local gt = this.getroottable();

gt.MSU.modItemContainer <- function ()
{
	::mods_hookNewObject("items/item_container", function(o) {
		o.m.ActionSkill <- null;

		o.isActionAffordable = function ( _items )
		{
			local actionCost = this.getActionCost(_items);
			return this.m.Actor.getActionPoints() >= actionCost;
		}

		o.getActionCost = function( _items )
		{
			this.m.ActionSkill = null;

			local info = this.getActor().getSkills().getItemActionCost(_items);

			local sortByItemActionOrder = function(_info1, _info2) {
				if (_info1.Skill.getItemActionOrder() < _info2.Skill.getItemActionOrder())
				{
					return -1;
				}
				else if (_info1.Skill.getItemActionOrder() > _info2.Skill.getItemActionOrder())
				{
					return 1;
				}
				else
				{
					return 0;
				}
			}

			info.sort(sortByItemActionOrder);

			local cost = this.Const.Tactical.Settings.SwitchItemAPCost;

			foreach (i in info)
			{
				if (i.Cost < cost)
				{
					cost = i.Cost;
					this.m.ActionSkill = i.Skill;
				}
			}

			return cost;
		}

		o.payForAction = function ( _items )
		{
			local actionCost = this.getActionCost(_items);
			this.m.Actor.setActionPoints(this.Math.max(0, this.m.Actor.getActionPoints() - actionCost));

			this.m.Actor.getSkills().onPayForItemAction(this.m.ActionSkill, _items);

			this.m.Actor.getSkills().update();
		}

		local onNewRound = o.onNewRound;
		o.onNewRound = function()
		{
			onNewRound();
			this.m.ActionCost = this.Const.Tactical.Settings.SwitchItemAPCost;
		}
	});
}
