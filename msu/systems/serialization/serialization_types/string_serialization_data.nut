::MSU.Class.StringSerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationData.String;

	constructor( _data )
	{
		::MSU.requireString(_data);
		base.constructor( _data);
	}
}
