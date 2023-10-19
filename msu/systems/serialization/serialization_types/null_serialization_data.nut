::MSU.Class.NullSerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationDataType.Null;
	constructor()
	{
		base.constructor(null);
	}
}
