// emulates the metadata object that can be gotten from _in.getMetadata() or _out.getMetadata() during on(De)Serialize function calls
::MSU.Class.MetaDataEmulator <- class
{
	Version = null;
	Data = null;
	RealMeta = null;
	Name = null;
	ModificationDate = null;
	CreationDate = null;
	FileName = null;

	constructor()
	{
		this.Data = {};
		this.Version = ::Const.Serialization.Version;
	}

	// this would ideally be an alternative static constructor
	function setRealMeta( __realMeta )
	{
		this.Version = null;
		this.RealMeta = __realMeta;
	}

	function setVersion( _version )
	{
		this.Version = _version;
	}

	function __getValue( _key )
	{
		return this.Data[_key];
	}

	function __setValue( _key, _value )
	{
		this.Data[_key] <- _value;
	}

	function getInt( _key )
	{
		if (_key in this.Data || this.RealMeta == null)
			return this.__getValue(_key);
		return this.RealMeta.getInt(_key);
	}

	function setInt( _key, _value)
	{
		::MSU.requireInt(_value);
		this.__setValue(_key, _value);
	}

	function getFloat( _key )
	{
		if (_key in this.Data || this.RealMeta == null)
			return this.__getValue(_key);
		return this.RealMeta.getFloat(_key);
	}

	function setFloat( _key, _value )
	{
		::MSU.requireOneFromTypes(["float", "integer"], _value);
		this.__setValue(_key, _value);
	}

	function getString( _key )
	{
		if (_key in this.Data || this.RealMeta == null)
			return this.__getValue(_key);
		return this.RealMeta.getString(_key);
	}

	function setString( _key, _value )
	{
		::MSU.requireString(_value);
		this.__setValue(_key, _value);
	}

	function __hasDataRaw( _key )
	{
		return _key in this.Data;
	}

	function hasData( _key )
	{
		// not sure if RealMeta hasData should be checked here
		// this could cause problems if something sets a key in metadata
		// and doesn't set it if it already exists in RealMeta
		// because we would then not know that we need to serialize that key
		// the problem I have right now is with types
		// we don't know the type of the value in RealMeta
		// so we don't know which get<XYZ> to use
		return this.__hasDataRaw(_key) || this.RealMeta.hasData(_key);
	}

	function getName()
	{
		if (this.RealMeta == null || this.RealMeta.getName() == null)
			return this.Name;
		return this.RealMeta.getName();
	}

	function getVersion()
	{
		if (this.RealMeta == null || this.RealMeta.getVersion() == null)
			return this.Version;
		return this.RealMeta.getVersion();
	}

	function getModificationDate()
	{
		if (this.RealMeta == null || this.RealMeta.getModificationDate() == null)
			return this.ModificationDate;
		return this.RealMeta.getModificationDate();
	}

	function getCreationDate()
	{
		if (this.RealMeta == null || this.RealMeta.getCreationDate() == null)
			return this.CreationDate;
		return this.RealMeta.getCreationDate();
	}

	function getFileName()
	{
		if (this.RealMeta == null || this.RealMeta.getFileName() == null)
			return this.FileName;
		return this.RealMeta.getFileName();
	}

	function __setUpDummyAssetsAndReturnCleanup()
	{
		local cleanup;
		if ("Assets" in ::World && !::MSU.isNull(::World.Assets))
		{
			cleanup = function() {};
		}
		else
		{
			local assets = ::new("scripts/states/world/asset_manager")
			::World.Assets <- ::WeakTableRef(assets);
			cleanup = function() {
				::World.Assets = null;
				::Stash = null;
				assets = null;
			};
		}
		return cleanup;
	}

	function serialize( _out )
	{
		if (::MSU.System.Serialization.MidOnBeforeSerialize)
		{
			throw "Can't serialize metadata during onBeforeSerialize!";
		}
		local realMeta = this.RealMeta;
		local knownValues = {};
		local dummyMeta = {
			function setInt(_key, _value) {
				knownValues[_key] <- ::MSU.Serialization.DataType.I32;
				realMeta.setInt(_key, _value);
			}
			function setFloat(_key, _value) {
				knownValues[_key] <- ::MSU.Serialization.DataType.F32;
				realMeta.setFloat(_key, _value);
			}
			function setString(_key, _value) {
				knownValues[_key] <- ::MSU.Serialization.DataType.String;
				realMeta.setString(_key, _value);
			}
		};
		dummyMeta.setdelegate({
			function _get(_key) {
				// I hate this bindenv but scope gets messed up otherwise
				return realMeta[_key].bindenv(realMeta);
			}
		})
		local dummyWorld = ::new("scripts/states/world_state");
		local serDeData = ::MSU.Serialization.Class.SerializationData();
		local serEmu = serDeData.getSerializationEmulator();
		serEmu.MetaData = dummyMeta;

		local cleanupDummyAssets = this.__setUpDummyAssetsAndReturnCleanup()
		dummyWorld.onBeforeSerialize(serEmu);
		cleanupDummyAssets();

		local data = clone this.Data;
		foreach (key, type in knownValues)
		{
			switch (type)
			{
				case ::MSU.Serialization.DataType.I32:
					data[key] <- this.getInt(key);
					break;
				case ::MSU.Serialization.DataType.F32:
					data[key] <- this.getFloat(key);
					break;
				case ::MSU.Serialization.DataType.String:
					data[key] <- this.getString(key);
					break;
			}
		}

		_out.writeU8(this.getVersion());
		_out.writeString(this.getName());
		_out.writeString(this.getFileName());
		_out.writeString(this.getCreationDate());
		_out.writeString(this.getModificationDate());
		::MSU.Serialization.serialize(data, _out);
	}

	function deserialize( _in )
	{
		this.Version = _in.readU8();
		this.Name = _in.readString();
		this.FileName = _in.readString();
		this.CreationDate = _in.readString();
		this.ModificationDate = _in.readString();
		this.Data = ::MSU.Serialization.deserialize(_in);
	}

	function _cloned( _original )
	{
		this.Version = _original.Version;
		this.Name = _original.Name;
		this.ModificationDate = _original.ModificationDate;
		this.CreationDate = _original.CreationDate;
		this.FileName = _original.FileName;
		this.RealMeta = _original.RealMeta;
		this.Data = clone _original.Data;
	}
}
