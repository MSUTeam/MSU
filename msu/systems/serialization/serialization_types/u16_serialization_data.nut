::MSU.Class.U16SerializationData <- class extends ::MSU.Class.BasicSerializationData
{
	static __Type = ::MSU.System.Serialization.SerializationDataType.U16;

	constructor( _data )
	{
		::MSU.requireInt(_data);
		if (_data < 0 || _data > 65535)
			throw ::MSU.Exception.InvalidValue(_data);
		base.constructor(_data);
	}
}
