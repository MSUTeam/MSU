local gt = this.getroottable();

gt.MSU.modItem <- function ()
{
	gt.Const.Items.addNewItemType <- function( _itemType )
	{
		if (_itemType in this.Const.Items.ItemType)
		{
			this.logError("addNewItemType: \'" + _itemType + "\' already exists.");
			return;
		}

		local max = 0;
		foreach (w, value in this.Const.Items.ItemType)
		{
			if (value > max)
			{
				max = value;
			}
		}
		this.Const.Items.ItemType[_itemType] <- max << 1;
	}

	::mods_hookBaseClass("items/item", function(o) {
		o = o[o.SuperName];

		o.addItemType <- function ( _t )
		{
			this.m.ItemType = this.m.ItemType | _t;
		}

		o.setItemType <- function( _t )
		{
			this.m.ItemType = _t;
		}

		o.removeItemType <- function( _t )
		{
			if (this.isItemType(_t))
			{
				this.m.ItemType -= _t;		
			}
		}
	});
}
