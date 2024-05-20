::MSU.HooksHelper <- {
	function addBaseItemToNamedItem( _script )
	{
		::MSU.HooksMod.hook(_script, function(q) {
			q.m.BaseItemScript <- null;
			q.m.MSU_PreventRandomize <- false;

			q.getBaseItemFields <- function()
			{
				return [];
			}

			q.setValuesBeforeRandomize <- function()
			{
				if (this.m.BaseItemScript != null)
				{
					local baseM = ::new(this.m.BaseItemScript).m;
					foreach (field in this.getBaseItemFields())
					{
						if (field == "ItemType")
							this.m[field] = this.m.ItemType | baseM.ItemType;
						else
							this.m[field] = baseM[field];
					}
				}
			}
		});

		::MSU.QueueBucket.VeryLate.push(function() {
			::MSU.HooksMod.hookTree(_script, function(q) {
				q.create = @(__original) function()
				{
					// Prevent the vanilla call to this.randomizeValues() within create() from randomizing anything
					// because we want to set the values from the base item first.
					this.m.MSU_PreventRandomize = true;
					__original();
					this.m.MSU_PreventRandomize = false;

					this.setValuesBeforeRandomize();
					this.randomizeValues();
				}

				q.randomizeValues = @(__original) function()
				{
					if (!this.m.MSU_PreventRandomize)
						return __original();
				}
			});
		});
	}
}
