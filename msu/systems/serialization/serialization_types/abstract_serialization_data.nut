::MSU.Class.AbstractSerializationData <- class
{
	static __Type = ::MSU.Utils.SerializationDataType.None;
	__Data = null;
	static DataType = ::MSU.Utils.SerializationDataType;

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
		_out["write" + ::MSU.Utils.SerializationDataType.getKeyForValue(this.getType())](this.getData());
	}

	function getData()
	{
		return this.__Data;
	}
}