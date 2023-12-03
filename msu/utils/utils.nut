::MSU.Utils <- {
	DataType = {
		Integer = 0,
		Float = 1,
		Boolean = 2,
		String = 3,
		Array = 4,
		Table = 5,
		Class = 6,
		Instance = 7,
		Null = 8
	},
	Timers = {}
	States = {},

	// deprecated - use ::MSU.Serialization.serialize instead
	function serialize( _object, _out )
	{
		::MSU.requireOneFromTypes(["array", "table"], _object);

		local type = typeof _object;
		local isTable = type == "table";

		if (isTable) _out.writeU8(this.DataType.Table);
		else _out.writeU8(this.DataType.Array);

		_out.writeU32(_object.len());

		foreach (key, element in _object)
		{
			if (isTable) _out.writeString(key);
			local dataType = typeof element;

			switch (dataType)
			{
				case "integer":
					_out.writeU8(this.DataType.Integer);
					if (element < 0)
					{
						_out.writeBool(true);
						_out.writeI32(element);
					}
					else
					{
						_out.writeBool(false);
						_out.writeU32(element);
					}
					break;

				case "float":
					_out.writeU8(this.DataType.Float);
					_out.writeF32(element);
					break;

				case "bool":
					_out.writeU8(this.DataType.Boolean);
					_out.writeBool(element);
					break;

				case "string":
					_out.writeU8(this.DataType.String);
					_out.writeString(element);
					break;

				case "array":
					_out.writeU8(this.DataType.Array);
					this.serialize(element, _out);
					break;

				case "table":
					_out.writeU8(this.DataType.Table);
					this.serialize(element, _out);
					break;

				case "null":
					_out.writeU8(this.DataType.Null);
					break;

				default:
					throw ::MSU.Exception.InvalidType(element);
			}
		}
	}

	// deprecated - use ::MSU.Serialization.deserialize instead
	function deserialize( _in )
	{
		local type = _in.readU8();
		local isTable = type == this.DataType.Table;
		local size = _in.readU32();

		local ret = isTable ? {} : array(size);

		for (local i = 0; i < size; i++)
		{
			local key = isTable ? _in.readString() : null;
			local dataType = _in.readU8();
			local val;

			switch (dataType)
			{
				case this.DataType.Integer:
					val = _in.readBool() ? _in.readI32() : _in.readU32();
					break;

				case this.DataType.Float:
					val = _in.readF32();
					break;

				case this.DataType.Boolean:
					val = _in.readBool();
					break;

				case this.DataType.String:
					val = _in.readString();
					break;

				case this.DataType.Array:
				case this.DataType.Table:
					val = this.deserialize(_in);
					break;

				case this.DataType.Null:
					val = null;
					break;
				default:
					throw ::MSU.Exception.InvalidType(dataType);
			}

			if (isTable) ret[key] <- val;
			else ret[i] = val;
		}

		return ret;
	}

	// deprecated - use ::MSU.Serialization.deserializeInto instead
	function deserializeInto( _object, _in )
	{
		::MSU.requireOneFromTypes(["table", "array"], _object);

		local deserializedObj = ::MSU.Utils.deserialize(_in);

		if (typeof _object == "table") return ::MSU.Table.merge(_object, deserializedObj);

		_object.resize(::Math.max(_object.len(), deserializedObj.len()));
		foreach (i, value in deserializedObj)
		{
			_object[i] = value;
		}
		return _object;
	}

	function operatorCompare( _compareResult, _operator )
	{
		switch (_compareResult)
		{
			case -1:
				if (["<", "<="].find(_operator) != null) return true;
				return false;

			case 0:
				if (["<=", "=", null, ">="].find(_operator) != null) return true;
				return false;

			case 1:
				if ([">", ">="].find(_operator) != null) return true;
				return false;
		}
		throw ::MSU.InvalidValue(_compareResult);
	}

	function getActiveState()
	{
		foreach (name, state in this.States)
		{
			if (!state.isNull() && state.isVisible() && name != "root_state")
			{
				return state;
			}
		}
	}

	function hasState(_id)
	{
		return (_id in this.States && !this.States[_id].isNull());
	}

	function getState(_id)
	{
		if (!(_id in this.States))
		{
			::logError("_id must be a valid state name!");
			throw ::MSU.Exception.KeyNotFound(_id);
		}
		return this.States[_id];
	}

	function Timer(_id)
	{
		if (_id in this.Timers) return this.Timers[_id];
	    this.Timers[_id] <- ::MSU.Class.Timer(_id);
	    return this.Timers[_id];
	}

	function benchmark( _functions, _iterations = 100000 )
	{
		// _functions can be a function to be benchmarked
		// or an array of len 2 arrays where idx 0 is an id (can be string) and idx 1 is function to be benchmarked
		if (typeof _functions == "function")
			_functions = [["", _functions]];

		local times = array(_functions.len());
		local timer = ::MSU.Class.Timer("MSU_Benchmark");

		foreach (i, entry in _functions)
		{
			local timeStart = timer.silentGet();
			local f = entry[1];

			for (local j = 0; j < _iterations; j++)
			{
				f();
			}

			local totalTime = timer.silentGet() - timeStart;

			times[i] = {
				TotalTime = totalTime,
				TimePerIteration = totalTime / _iterations
			};
		}

		foreach (i, entry in times)
		{
			local diff = entry.TimePerIteration - times[0].TimePerIteration;
			local color = i == 0 ? "" : (diff <= 0 ? "green" : "red"); // the base function is printed without color, faster in green, slower in red

			local timePerIterationText = format("<div style='display: inline-block; color:%s;'>%f (%s%f)</div>", color, entry.TimePerIteration, diff >= 0 ? "+" : "", diff);
			diff = entry.TotalTime - times[0].TotalTime;
			local totalTimeText = entry.TotalTime + (diff < 0 ? " (" : " (+") + diff + ")";
			local timePctText = format("<div style='display: inline-block; color:%s'>%i%% %s</div>", color, ::Math.abs(100 * diff / times[0].TotalTime), diff < 0 ? "faster" : "slower");
			::logInfo(format("<div style='display: inline-block;'>%s: %s ms (Total: %s ms) -- %s</div>", _functions[i][0] + "", timePerIterationText, totalTimeText, i == 0 ? "base time" : timePctText));
		}
	}

	// Deprecated - use ::MSU.AI.addBehavior instead
	function addAIBehaviour(_id, _name, _order, _score = null)
	{
		return ::MSU.AI.addBehavior(_id, _name, _order, _score);
	}
}
