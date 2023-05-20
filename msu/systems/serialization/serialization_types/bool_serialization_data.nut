::MSU.Class.BoolSerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationData.Bool;

	constructor(_data)
	{
		::MSU.requireBool(_data);
		base.constructor(_data);
	}
}
