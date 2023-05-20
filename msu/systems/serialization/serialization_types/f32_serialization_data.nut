::MSU.Class.F32SerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationData.F32;

	constructor( _data )
	{
		::MSU.requireFloat(_data);
		base.constructor(_data);
	}
}
