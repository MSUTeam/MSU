::MSU.Class.ArraySerializationData <- class extends ::MSU.Class.SerializationDataCollection
{
	static __Type = ::MSU.System.Serialization.SerializationDataType.Array;

	constructor( _data )
	{
		if (_data == null)
			_data = [];
		::MSU.requireArray(_data);

		base.constructor(_data);
		this.Collection.resize(_data.len())
		foreach (i, element in _data)
		{
			this.Collection[i] =  ::MSU.System.Serialization.convertValueFromBaseType(element);
		}
	}

	function deserialize( _in )
	{
		base.deserialize(_in);
		this.__Data.resize(this.Collection.len());
		for (local i = 0; i < this.Collection.len(); ++i)
		{
			this.__Data[i] = this.Collection[i].getData();
		}
	}
}
