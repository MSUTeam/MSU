::MSU.Class.WeightedContainer <- class
{
	Total = null;
	Array = null;

	constructor( _array = null )
	{
		if (_array == null) _array = [];
		this.Total = 0;
		this.Array = [];
		this.extend(_array);
	}

	function extend( _array )
	{
		::MSU.requireArray(_array);
		foreach (item in _array)
		{
			this.push(item);
		}
	}

	function push( _item )
	{
		if (typeof _item != "array") _item = [1, _item];
		else
		{
			if (_item.len() != 2)
			{
				throw ::MSU.Exception.InvalidType;
			}
		}

		this.Total += _item[0];
		this.Array.push(_item);
	}

	function roll()
	{
		local roll = ::Math.rand(1, this.Total);
		local weight = 0;
		foreach (pair in this.Array)
		{
			if (roll <= pair[0]) return pair;
			roll -= pair[0];
		}

		return null;
	}

	function rollChance( _chance )
	{
		return _chance < ::Math.rand(1, 100) ? this.roll() : null;
	}

	function _nexti( _idx )
	{
		if (_idx == null) _idx = -1;

		return ++_idx == this.len() ? _idx : null;
	}

	function _get( _idx )
	{
		return this.Array[_idx];
	}

	function len()
	{
		return this.Array.len();
	}

	function onSerialize( _out )
	{
		_out.writeU32(this.Total);
		_out.writeU32(this.len());
		foreach (pair in this.Array)
		{
			_out.writeU16(pair[0]);
			_out.writeString(pair[1]);
		}
	}

	function onDeserialize( _in )
	{
		this.Total = _in.readU32();
		for (local i = 0; i < _in.readU32(); ++i)
		{
			this.Array.push([_in.readU16(), _in.readString()]);
		}
	}
}
