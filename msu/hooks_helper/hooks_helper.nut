::MSU.HooksHelper <- {
	function addBaseItemToNamedItem( _script )
	{
		::MSU.MH.hook(_script, function(q) {
			q.m.BaseItemScript <- null;

			q.getBaseItemFields <- function()
			{
				return [];
			}

			q.setValuesBeforeRandomize <- function( _baseItem )
			{
				if (_baseItem != null)
				{
					foreach (field in this.getBaseItemFields())
					{
						this.m[field] = _baseItem.m[field];
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

					local hasNamedItemType = this.isItemType(::Const.Items.ItemType.Named);
					this.setValuesBeforeRandomize(this.m.BaseItemScript != null ? ::new(this.m.BaseItemScript) : null);
					if (hasNamedItemType)
						this.m.ItemType = this.m.ItemType | ::Const.Items.ItemType.Named; // Re-add the named item type that got overwritten from the base item

					this.randomizeValues();
				}
			});
		});
	}
}
