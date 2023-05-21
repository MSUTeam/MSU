::MSU.Class.U32SerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationDataType.U32;

	constructor( _data )
	{
		::MSU.requireInt(_data);
		if (_data < 0)
			throw ::MSU.Exception.InvalidValue(_data);
		base.constructor(_data);
	}
}
