::MSU.Class.Enum <- class
{
	_Keys = null;
	_ValueKeyArray = null;

	constructor( _array = null )
	{
		this._Keys = {};
		this._ValueKeyArray = [];
		if (_array != null) this.addArray(_array);
	}

	function _isValidKey( _key )
	{
		return typeof _key == "string" && _key != "" && _key.slice(0,1).tolower() != _key.slice(0,1);
	}

	function add( _key )
	{
		if (!this._isValidKey(_key))
		{
			::logError("MSU Enum Keys must be non-empty strings and start with a capitalized letter");
			throw ::MSU.Exception.InvalidValue(_key);
		}
		this._Keys[_key] <- this._Keys.len();
		this._ValueKeyArray.push(_key);
	}

	function addArray( _array )
	{
		foreach (value in _array) this.add(value);
	}

	function getKeyForValue( _value )
	{
		return this._ValueKeyArray[_value];
	}

	function len()
	{
		return this._Keys.len();
	}

	function _get( _key )
	{
		if (_key in this._Keys) return this._Keys[_key];
		throw null;
	}
}
