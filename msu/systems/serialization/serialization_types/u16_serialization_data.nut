::MSU.Class.U16SerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationData.U16;

	constructor( _data )
	{
		::MSU.requireInt(_data);
		if (_data < 0 || _data > 65535)
			throw ::MSU.Exception.InvalidValue(_data);
		base.constructor(_data);
	}
}
