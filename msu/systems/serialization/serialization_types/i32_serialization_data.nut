::MSU.Class.I32SerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationData.I32;

	constructor( _data )
	{
		::MSU.requireInt(_data);
		base.constructor(_data);
	}
}
