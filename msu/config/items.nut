this.Const.Items.ItemTypeName <- [];
this.Const.Items.ItemTypeName.resize(this.Const.Items.ItemType.len(), "");

foreach (itemType in this.Const.Items.ItemType)
{
	local name = "";
	switch (itemType)
	{
		case this.Const.Items.ItemType.Legendary:
			name = "Legendary Item";
			break;

		case this.Const.Items.ItemType.Named:
			name = "Famed Item";				
			break;

		case this.Const.Items.ItemType.Tool:
			name = "Tool";				
			break;

		case this.Const.Items.ItemType.Crafting:
			name = "Crafting Item";				
			break;

		case this.Const.Items.ItemType.TradeGood:
			name = "Trade Good";				
			break;
	}
	local idx = ::MSU.Math.log2int(itemType) + 1;
	this.Const.Items.ItemTypeName[idx] = name;
}

this.Const.Items.addNewItemType <- function( _itemType, _name = "" )
{
	if (_itemType in this.Const.Items.ItemType)
	{
		this.logError("addNewItemType: \'" + _itemType + "\' already exists.");
		return;
	}

	local max = 0;
	foreach (w, value in this.Const.Items.ItemType)
	{
		if (value > max) max = value;
	}

	local val = max << 1;
	this.Const.Items.ItemType[_itemType] <- val;
	this.Const.Items.ItemFilter.All = this.Const.Items.ItemFilter.All | val;
	this.Const.Items.ItemTypeName.push(_name);
}

this.Const.Items.getItemTypeName <- function( _itemType )
{
	local idx = ::MSU.Math.log2int(_itemType) + 1;
	if (idx < this.Const.Items.ItemTypeName.len())
	{
		return this.Const.Items.ItemTypeName[idx];
	}

	this.logError("getItemTypeName: _itemType \'" + _itemType + "\' does not exist");
	return "";
}

this.Const.Items.WeaponType <- {
	None = 0,
	Axe = 1,
	Bow = 2,
	Cleaver = 4,
	Crossbow = 8,
	Dagger = 16,
	Firearm = 32,
	Flail = 64,
	Hammer = 128,
	Mace = 256,
	Polearm = 512,
	Sling = 1024,
	Spear = 2048,
	Sword = 4096,
	Staff = 8192,
	Throwing = 16384,
	Musical = 32768
}

this.Const.Items.WeaponTypeName <- [
	"No Weapon Type",
	"Axe",
	"Bow",
	"Cleaver",
	"Crossbow",
	"Dagger",
	"Firearm",
	"Flail",
	"Hammer",
	"Mace",
	"Polearm",
	"Sling",
	"Spear",
	"Sword",
	"Staff",
	"Throwing Weapon",
	"Musical Instrument"
]

this.Const.Items.getWeaponTypeName <- function( _weaponType )
{
	local idx = ::MSU.Math.log2int(_weaponType) + 1;
	if (idx < this.Const.Items.WeaponTypeName.len())
	{
		return this.Const.Items.WeaponTypeName[idx];
	}

	this.logError("getWeaponTypeName: _weaponType \'" + _weaponType + "\' does not exist");
	return "";
}

this.Const.Items.addNewWeaponType <- function( _weaponType, _weaponTypeName = "" )
{
	if (_weaponType in this.Const.Items.WeaponType)
	{
		this.logError("addNewWeaponType: \'" + _weaponType + "\' already exists.");
		return;
	}

	local max = 0;
	foreach (w, value in this.Const.Items.WeaponType)
	{
		if (value > max)
		{
			max = value;
		}
	}
	this.Const.Items.WeaponType[_weaponType] <- max << 1;

	if (_weaponTypeName == "")
	{
		_weaponTypeName = _weaponType;
	}

	this.Const.Items.WeaponTypeName.push(_weaponTypeName);
}
