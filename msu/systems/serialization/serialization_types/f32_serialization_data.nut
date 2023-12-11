::MSU.Class.F32SerializationData <- class extends ::MSU.Class.BasicSerializationData
{
	static __Type = ::MSU.System.Serialization.SerializationDataType.F32;

	constructor( _data )
	{
		::MSU.requireOneFromTypes(["float", "integer"], _data);
		base.constructor(_data);
	}
}
