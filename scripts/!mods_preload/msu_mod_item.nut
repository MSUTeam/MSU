local gt = this.getroottable();

gt.MSU.modItem <- function ()
{
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
