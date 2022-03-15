::MSU.Class.SystemModAddon <- class
{
	Parent = null;
	constructor(_parent)
	{
		this.Parent = _parent;
	}

	function getParent()
	{
		return this.Parent;
	}

	function getID()
	{
		return this.getParent().getID();
	}
}
