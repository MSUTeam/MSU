::MSU.Class.AbstractSerializationData <- class
{
	static __Type = ::MSU.System.Serialization.SerializationDataType.None;
	__Data = null;

	constructor( _data )
	{
		this.__Data = _data;
	}

	function getType()
	{
		return this.__Type;
	}

	function serialize( _out )
	{
		_out.writeU8(this.getType());
	}

	function getData()
	{
		return this.__Data;
	}
}
