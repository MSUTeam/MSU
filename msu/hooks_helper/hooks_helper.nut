::MSU.HooksHelper <- {
	function addBaseItemToNamedItem( _script )
	{
		::MSU.HooksMod.hook(_script, function(q) {
			q.m.BaseItemScript <- null;
			q.m.BaseItemFields <- [];
			q.setValuesBeforeRandomize <- function()
			{
				if (this.m.BaseItemScript != null)
				{
					local baseM = ::new(this.m.BaseItemScript).m;
					foreach (field in this.m.BaseItemFields)
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
			::MSU.HooksMod.hook(_script, function(q) {
				q.randomizeValues = @(__original) function()
				{
					this.setValuesBeforeRandomize();
					return __original();
				}
			});
		});
	}
}
