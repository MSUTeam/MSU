::MSU.Class.I8SerializationData <- class extends ::MSU.Class.BasicSerializationData
{
	static __Type = ::MSU.System.Serialization.SerializationDataType.I8;

	constructor( _data )
	{
		::MSU.requireInt(_data);
		if (_data < -128 || _data > 127)
			throw ::MSU.Exception.InvalidValue(_data);
		base.constructor(_data);
	}
}
