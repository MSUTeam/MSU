::MSU.Class.U8SerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationDataType.U8;

	constructor( _data )
	{
		::MSU.requireInt(_data);
		if (_data < 0 || _data > 255)
			throw ::MSU.Exception.InvalidValue(_data);
		base.constructor(_data);
	}
}
