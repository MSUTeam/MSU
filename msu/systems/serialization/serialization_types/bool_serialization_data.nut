::MSU.Class.BoolSerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationDataType.Bool;

	constructor(_data)
	{
		::MSU.requireBool(_data);
		base.constructor(_data);
	}
}
