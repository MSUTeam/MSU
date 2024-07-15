::MSU.isNull <- function( _object )
{
	return _object == null || (_object instanceof ::WeakTableRef && _object.isNull());
}

::MSU.getField <- function( _object, _key )
{
	if (typeof _object == "instance")
	{
		if (_object instanceof ::WeakTableRef)
		{
			if (_object.isNull())
			{
				::printError("The table inside the WeakTableRef instance is null");
				throw ::MSU.Exception.KeyNotFound(_object);
			}
			_object = _object.get();
		}
		else throw ::MSU.Exception.InvalidType(_object);
	}

	_object = _object.m;

	do
	{
		if (_key in _object) return _object[_key];
		_object = _object.getdelegate();
	}
	while(_object != null);

	throw ::MSU.Exception.KeyNotFound(_key);
}

::MSU.getMember <- function( _object, _key )
{
	if (typeof _object == "instance")
	{
		if (_object instanceof ::WeakTableRef)
		{
			if (_object.isNull())
			{
				::printError("The table inside the WeakTableRef instance is null");
				throw ::MSU.Exception.KeyNotFound(_object);
			}
			_object = _object.get();
		}
		else throw ::MSU.Exception.InvalidType(_object);
	}

	do
	{
		if (_key in _object) return _object[_key];
		_object = _object.getdelegate();
	}
	while(_object != null);

	throw ::MSU.Exception.KeyNotFound(_key);
}

::MSU.isIn <- function( _member, _object, _chain = false )
{
	if (_object == null) return false;
	switch (typeof _object)
	{
		case "instance":
			if (!(_object instanceof ::WeakTableRef)) return _member in _object;
			if (_object.isNull()) return false;
			_object = _object.get();
		case "table":
			if (!_chain) return _member in _object;
			do
			{
				if (_member in _object) return true;
				_object = _object.getdelegate();
			}
			while(_object != null);
			return false;

		case "array":
			return _object.find(_member) != null;

		default:
			return false;
	}

	return false;
}

::MSU.isKindOf <- function( _object, _className )
{
	if (_object == null || _className == null) return false;
	if (_object instanceof ::WeakTableRef)
	{
		if (_object.isNull()) return false;
		_object = _object.get();
	}

	return ::isKindOf(_object, _className);
}

::MSU.asWeakTableRef <- function( _object )
{
	if (typeof _object == "instance")
	{
		if (_object instanceof ::WeakTableRef) return _object;
		throw ::MSU.Exception.InvalidType(_object);
	}
	return ::WeakTableRef(_object);
}

::MSU.regexMatch <- function( _capture, _string, _group )
{
	return _capture[_group].end > 0 && _capture[_group].begin < _string.len() ? _string.slice(_capture[_group].begin, _capture[_group].end) : null;
}

::MSU.isEqual <- function( _1, _2 )
{
	if (_1 instanceof ::WeakTableRef) _1 = _1.get();
	if (_2 instanceof ::WeakTableRef) _2 = _2.get();

	return _1 == _2;
}

::MSU.isBBObject <- function( _object, _allowWeakTableRef = true )
{
	if (_object instanceof ::WeakTableRef && _allowWeakTableRef)
		_object = _object.get();
	return typeof _object == "table" && "_release_hook_DO_NOT_delete_it_" in _object;
}

::MSU.deepClone <- function( _object )
{
	local ret;
	switch (typeof _object)
	{
		case "table":
			ret = {};
			if (_object.getdelegate() != null)
				ret.setdelegate(::MSU.deepClone(_object.getdelegate()));
			foreach (key, value in _object)
				ret[key] <- ::MSU.deepClone(value);
			return ret;
		case "array":
			return _object.map(@(_o) ::MSU.deepClone(_o));
		case "instance":
			return clone _object;
		default:
			return _object;
	}
}

::MSU.deepEquals <- function(_a, _b)
{
	if (_a instanceof ::WeakTableRef)
		_a = _a.get();
	if (_b instanceof ::WeakTableRef)
		_b = _b.get();
	switch (typeof _a)
	{
		case "table":
			if (_a.len() != _b.len())
				return false;
			foreach (k, v in _a)
			{
				if (!(k in _b) || !this.deepEquals(v, _b[k]))
					return false;
			}
			return true;
		case "array":
			if (_a.len() != _b.len())
				return false;
			foreach (i, v in _a)
			{
				if (!this.deepEquals(v, _b[i]))
					return false;
			}
			return true;
		case "instance":
			if (!(typeof _b != "instance") || _a.getclass() != _b.getclass())
				return false;
			foreach (k, v in _a.getclass())
			{
				if (!this.deepEquals(v, _b[k]))
					return false;
			}
			return true;
		default:
			return _a == _b;
	}
}

::MSU.DummyPlayer <- null;
::MSU.getDummyPlayer <- function()
{
	if (this.DummyPlayer == null)
	{
		local roster = ::World.createRoster("MSU_Roster");
		this.DummyPlayer = roster.create("scripts/entity/tactical/player");
		this.DummyPlayer.m.Name = "MSU Dummy Player";
	}
	return this.DummyPlayer;
}
