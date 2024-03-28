::MSU.Class.AbstractData <- class
{
	__Type = null;
	__Data = null;

	constructor( _type, _data )
	{
		this.__Type = _type;
		this.__Data = _data;
	}

	function getType()
	{
		return this.__Type;
	}

	function getData()
	{
		return this.__Data;
	}

	function serialize( _out )
	{
		_out.writeU8(this.__Type);
	}

	// Must be overridden by children
	function deserialize( _in )
	{
	}
}
