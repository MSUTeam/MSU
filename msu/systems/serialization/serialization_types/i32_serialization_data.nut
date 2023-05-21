::MSU.Class.I32SerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationDataType.I32;

	constructor( _data )
	{
		::MSU.requireInt(_data);
		base.constructor(_data);
	}
}
