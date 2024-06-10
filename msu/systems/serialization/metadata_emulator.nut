// emulates the metadata object that can be gotten from _in.getMetadata() or _out.getMetadata() during on(De)Serialize function calls
::MSU.Class.MetaDataEmulator <- class
{
	Version = null;
	Data = null;
	RealMetaData = null;
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
	function setRealMetaData( _realMetaData )
	{
		this.Version = null;
		this.RealMetaData = _realMetaData;
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
		if (_key in this.Data || this.RealMetaData == null)
			return this.__getValue(_key);
		return this.RealMetaData.getInt(_key);
	}

	function setInt( _key, _value)
	{
		::MSU.requireInt(_value);
		this.__setValue(_key, _value);
	}

	function getFloat( _key )
	{
		if (_key in this.Data || this.RealMetaData == null)
			return this.__getValue(_key);
		return this.RealMetaData.getFloat(_key);
	}

	function setFloat( _key, _value )
	{
		::MSU.requireOneFromTypes(["float", "integer"], _value);
		this.__setValue(_key, _value);
	}

	function getString( _key )
	{
		if (_key in this.Data || this.RealMetaData == null)
			return this.__getValue(_key);
		return this.RealMetaData.getString(_key);
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
		// not sure if RealMetaData hasData should be checked here
		// this could cause problems if something sets a key in metadata
		// and doesn't set it if it already exists in RealMetaData
		// because we would then not know that we need to serialize that key
		// the problem I have right now is with types
		// we don't know the type of the value in RealMetaData
		// so we don't know which get<XYZ> to use
		return this.__hasDataRaw(_key) || this.RealMetaData.hasData(_key);
	}

	function getName()
	{
		if (this.RealMetaData == null || this.RealMetaData.getName() == null)
			return this.Name;
		return this.RealMetaData.getName();
	}

	function getVersion()
	{
		if (this.RealMetaData == null || this.RealMetaData.getVersion() == null)
			return this.Version;
		return this.RealMetaData.getVersion();
	}

	function getModificationDate()
	{
		if (this.RealMetaData == null || this.RealMetaData.getModificationDate() == null)
			return this.ModificationDate;
		return this.RealMetaData.getModificationDate();
	}

	function getCreationDate()
	{
		if (this.RealMetaData == null || this.RealMetaData.getCreationDate() == null)
			return this.CreationDate;
		return this.RealMetaData.getCreationDate();
	}

	function getFileName()
	{
		if (this.RealMetaData == null || this.RealMetaData.getFileName() == null)
			return this.FileName;
		return this.RealMetaData.getFileName();
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
		if (::MSU.System.Serialization.IsDuringOnBeforeSerialize)
		{
			throw "attempting to serialize metadata during world_state.onBeforeSerialize";
		}
		local realMetaData = this.RealMetaData;
		local knownValues = {};
		local dummyMeta = {
			function setInt(_key, _value) {
				knownValues[_key] <- ::MSU.Serialization.DataType.I32;
				realMetaData.setInt(_key, _value);
			}
			function setFloat(_key, _value) {
				knownValues[_key] <- ::MSU.Serialization.DataType.F32;
				realMetaData.setFloat(_key, _value);
			}
			function setString(_key, _value) {
				knownValues[_key] <- ::MSU.Serialization.DataType.String;
				realMetaData.setString(_key, _value);
			}
		};
		dummyMeta.setdelegate({
			function _get(_key) {
				// I hate this bindenv but scope gets messed up otherwise
				return realMetaData[_key].bindenv(realMetaData);
			}
		})
		local dummyWorld = ::new("scripts/states/world_state");
		local serDeData = ::MSU.Class.SerializationData();
		local serEmu = serDeData.getSerializationEmulator();
		serEmu.MetaData = dummyMeta;

		local cleanupDummyAssets = this.__setUpDummyAssetsAndReturnCleanup()
		local serializationMetaData = ::MSU.System.Serialization.SerializationMetaData;
		dummyWorld.onBeforeSerialize(serEmu);
		::MSU.System.Serialization.SerializationMetaData = serializationMetaData;
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
		this.RealMetaData = _original.RealMetaData;
		this.Data = clone _original.Data;
	}
}
