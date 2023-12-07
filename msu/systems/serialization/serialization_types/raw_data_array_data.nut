::MSU.Class.RawDataArrayData <- class extends ::MSU.Class.CustomSerializationData
{
	static __Type = ::MSU.Utils.SerializationDataType.RawDataArray;
	__InnerArray = null;
	__MetaData = null;

	constructor()
	{
		base.constructor(null);
		this.__InnerArray = [];
	}

	// overridden functions

	function getData()
	{
		return this; // data_arrays should not be handled the same way as every other serialization data and should instead be passed directly
	}

	function setLength( _length )
	{
		this.__InnerArray.resize(_length);
	}

	function len()
	{
		return this.__InnerArray.len();
	}

	function deserialize( _in )
	{
		base.deserialize(_in);
		for (local i = 0; i < this.__InnerArray.len(); ++i)
		{
			this.__InnerArray[i] = this.__readValueFromStorage(_in);
		}
	}

	function serialize( _out )
	{
		base.serialize(_out);
		for (local i = 0; i < this.__InnerArray.len(); ++i)
		{
			this.__InnerArray[i].serialize(_out);
		}
	}

	// new functions

	function getElement( _idx )
	{
		return this.__InnerArray[_idx];
	}

	function setElement( _idx, _value )
	{
		this.__InnerArray[_idx] = _value;
	}

	function pushElement( _value )
	{
		this.__InnerArray.push(_value);
	}
}
