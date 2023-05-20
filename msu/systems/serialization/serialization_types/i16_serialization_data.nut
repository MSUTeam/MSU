::MSU.Class.I16SerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationData.I16;

	constructor( _data )
	{
		::MSU.requireInt(_data);
		if (_data < -32768 || _data > 32767)
			throw ::MSU.Exception.InvalidValue(_data);
		base.constructor(_data);
	}
}
