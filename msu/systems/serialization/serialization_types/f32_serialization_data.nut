::MSU.Class.F32SerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationDataType.F32;

	constructor( _data )
	{
		::MSU.requireOneFromTypes(["float", "integer"], _data);
		base.constructor(_data);
	}
}
