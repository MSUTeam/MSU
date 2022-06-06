::MSU.Class.Tooltip <- class
{
	Data = null;

	constructor(_data = null)
	{
		this.setData(_data);
	}

	function setData(_data)
	{
		::MSU.requireOneFromTypes(["table", "null"], _data);
		this.Data = _data == null ? {} : _data;
	}

	function getUIData(_data)
	{
		return null;
	}
}
