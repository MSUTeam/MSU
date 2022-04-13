::MSU.Class.WeightedContainer <- class
{
	Total = null;
	Array = null;
	ApplyIdx = null;
	Forced = null;

	constructor( _array = null )
	{
		this.Total = 0;
		this.Array = [];
		this.Forced = [];
		if (_array != null) this.addArray(_array);
	}

	function toArray( _itemsOnly = true )
	{
		local ret = array(this.Array.len(), null);
		foreach (i, pair in this.Array)
		{
			if (_itemsOnly) ret[i] = pair[1];
			else ret[i] = [pair[0], pair[1]];
		}
		return ret;
	}

	function addArray( _array )
	{
		::MSU.requireArray(_array);
		foreach (pair in _array)
		{
			::MSU.requireArray(pair);
			if (pair.len() != 2) throw ::MSU.Exception.InvalidType(pair);
			
			this.add(pair[1], pair[0]);
		}
	}

	function add( _item, _weight = 1 )
	{
		::MSU.requireOneFromTypes(["integer", "float"], _weight);

		this.Total += _weight;
		foreach (pair in this.Array)
		{
			if (pair[1] == _item)
			{
				local newWeight = pair[0] < 0 ? _weight : pair[0] + _weight;
				this.updateWeight(pair, newWeight);
				return;
			}
		}
		this.Array.push([_weight, _item]);
	}

	function contains( _item )
	{
		foreach (pair in this.Array)
		{
			if (pair[1] == _item) return true;
		}

		return false;
	}

	function remove( _item )
	{
		foreach (i, pair in this.Array)
		{
			if (pair[1] == _item)
			{
				this.updateWeight(pair[0], 0);
				return this.Array.remove(i)[1];
			}
		}

		throw ::MSU.Exception.KeyNotFound(_item);
	}

	function getProbability( _item, _exclude = null )
	{
		if (_exclude != null)
		{
			::MSU.requireArray(_exclude);
			if (_exclude.find(_item) != null) return 0.0;
		}

		local forced = _exclude == null ? this.Forced : this.Forced.filter(@(idx, pair) _exclude.find(pair[1]) == null);
		foreach (pair in forced)
		{
			if (pair[1] == _item) return 1.0 / forced.len();
		}
		if (forced.len() != 0) return 0.0;

		local weight = null;
		if (this.ApplyIdx != null && this.Array[this.ApplyIdx][1] == _item)
		{
			weight = this.Array[this.ApplyIdx][0];
		}
		else
		{
			foreach (pair in this.Array)
			{
				if (pair[0] > 0 && pair[1] == _item) weight = pair[0];
			}
		}

		// TODO: Need to account for a situation where total might be 0
		if (weight != null) return weight.tofloat() / this.getTotal(_exclude);
		
		throw ::MSU.Exception.KeyNotFound(_item);
	}

	function getWeight( _item )
	{
		foreach (pair in this.Array)
		{
			if (pair[1] == _item) return pair[0];
		}

		throw ::MSU.Exception.KeyNotFound(_item);
	}

	function setWeight( _item, _weight )
	{
		::MSU.requireOneFromTypes(["integer", "float"], _weight);

		if (this.ApplyIdx != null && this.Array[this.ApplyIdx][1] == _item)
		{
			this.updateWeight(this.Array[this.ApplyIdx], _weight);
			return;
		}

		foreach (pair in this.Array)
		{
			if (pair[1] == _item)
			{
				this.updateWeight(pair, _weight);
				return;
			}
		}

		throw ::MSU.Exception.KeyNotFound(_item);
	}

	// Private
	function updateWeight( _pair, _newWeight )
	{
		if (_pair[0] >= 0)
		{
			this.Total -= _pair[0];
			if (_newWeight < 0) this.Forced.push(_pair);
		}

		if (_newWeight >= 0)
		{
			this.Total += _newWeight;
			if (_pair[0] < 0) this.Forced.remove(this.Forced.find(_pair));
		}

		_pair[0] = _newWeight;
	}

	// Private
	function getTotal( _exclude = null )
	{
		if (_exclude == null) return this.Total;

		local ret = 0;
		foreach (pair in this.Array)
		{
			if (pair[0] >= 0 && _exclude.find(pair[1]) == null) ret += pair[0];
		}

		return ret;
	}

	function apply( _function )
	{
		// _function (_item, _weight)

		foreach (i, pair in this.Array)
		{
			this.ApplyIdx = i;
			_function(pair[1], pair[0]);
		}

		this.ApplyIdx = null;
	}

	function map( _function )
	{
		// _function (_item, _weight)

		local ret = ::MSU.Class.WeightedContainer();
		foreach (i, pair in this.Array)
		{
			this.ApplyIdx = i;
			ret.add(_function(pair[1], pair[0]));
		}
		this.ApplyIdx = null;
		return ret;
	}

	function filter( _function )
	{
		// _function (_item, _weight)

		local ret = ::MSU.Class.WeightedContainer();
		foreach (i, pair in this.Array)
		{
			this.ApplyIdx = i;
			if (_function(pair[1], pair[0])) ret.add(pair[1], pair[0]);
		}
		this.ApplyIdx = null;
		return ret;
	}

	function clear()
	{
		this.Total = 0;
		this.Array.clear();
		this.Forced.clear();
	}

	function top()
	{
		local weight = 0;
		local ret;

		foreach (pair in this.Array)
		{
			if (pair[0] > weight)
			{
				weight = pair[0];
				ret = pair[1];
			}
		}

		return ret;
	}

	function rand()
	{
		return ::MSU.Array.rand(this.Array)[1];
	}

	function roll( _exclude = null )
	{
		if (_exclude != null) ::MSU.requireArray(_exclude);

		local forced = _exclude == null ? this.Forced : this.Forced.filter(@(idx, pair) _exclude.find(pair[1]) == null);
		if (forced.len() > 0)
		{
			return ::MSU.Array.rand(forced)[1];
		}

		local roll = ::Math.rand(1, this.getTotal(_exclude));
		foreach (pair in this.Array)
		{
			if (_exclude != null && _exclude.find(pair[1]) != null) continue;

			if (roll <= pair[0]) return pair[1];

			roll -= pair[0];
		}

		return null;
	}

	function rollChance( _chance, _exclude = null )
	{
		return ::Math.rand(1, 100) <= _chance ? this.roll(_exclude) : null;
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

	function _cloned()
	{
		return ::MSU.Class.WeightedContainer(clone this.Array);
	}

	function len()
	{
		return this.Array.len();
	}

	function onSerialize( _out )
	{
		_out.writeU32(this.Total);
		::MSU.Utils.serialize(this.Array, _out);
	}

	function onDeserialize( _in )
	{
		this.Total = _in.readU32();
		this.Array = ::MSU.Utils.deserialize(_in);
	}
}
