::MSU.Class.I32SerializationData <- class extends ::MSU.Class.BasicSerializationData
{
	static __Type = ::MSU.System.Serialization.SerializationDataType.I32;

	constructor( _data )
	{
		::MSU.requireInt(_data);
		base.constructor(_data);
	}
}
