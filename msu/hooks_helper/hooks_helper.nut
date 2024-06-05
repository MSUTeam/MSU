::MSU.HooksHelper <- {
	function addBaseItemToNamedItem( _script )
	{
		::MSU.MH.hook(_script, function(q) {
			q.m.BaseItemScript <- null;

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
			::MSU.MH.hookTree(_script, function(q) {
				q.create = @(__original) function()
				{
					// Prevent the vanilla call to this.randomizeValues() within create() from randomizing anything
					// because we want to set the values from the base item first.
					local randomizeValues = this.randomizeValues;
					this.randomizeValues = @() null;
					__original();
					this.randomizeValues = randomizeValues;

					this.setValuesBeforeRandomize();
					this.randomizeValues();
				}
			});
		});
	}
}
