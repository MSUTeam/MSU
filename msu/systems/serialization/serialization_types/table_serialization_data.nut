::MSU.Class.TableSerializationData <- class extends ::MSU.Class.SerializationDataCollection
{
	static __Type = ::MSU.System.Serialization.SerializationDataType.Table;

	constructor( _data )
	{
		if (_data == null)
			_data = {};
		::MSU.requireTable(_data)

		base.constructor(_data);
		this.Collection.resize(_data.len() * 2);
		local i = 0;
		foreach (key, value in _data)
		{
			this.Collection[i++] = ::MSU.System.Serialization.convertValueFromBaseType(key);
			this.Collection[i++] = ::MSU.System.Serialization.convertValueFromBaseType(value);
		}
	}

	function deserialize( _in )
	{
		base.deserialize(_in);
		this.__Data = {};
		for (local i = 0; i < this.Collection.len(); i+=2)
		{
			this.__Data[this.Collection[i].getData()] <- this.Collection[i+1].getData();
		}
	}
}
