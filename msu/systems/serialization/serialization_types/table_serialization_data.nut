::MSU.Class.TableData <- class extends ::MSU.Class.ArrayData
{
	__DataArray = null;

	constructor( _data )
	{
		::MSU.requireTable(_data);

		local array = array(_data.len() * 2);
		local i = 0;
		foreach (key, value in _data)
		{
			array[i++] = key;
			array[i++] = value;
		}
		base.constructor(array);

		this.__Type = ::MSU.Utils.SerializationDataType.Table;
		this.__Data = _data;
	}

	function deserialize( _in )
	{
		base.deserialize(_in);
		local table = {};
		for (local i = 0; i < this.__Data.len(); i+=2)
		{
			table[this.__Data[i]] <- this.__Data[i+1];
		}
		this.__Data = table;
	}
}
