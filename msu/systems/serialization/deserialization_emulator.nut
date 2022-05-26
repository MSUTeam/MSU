::MSU.Class.DeserializationEmulator <- class extends ::MSU.Class.SerDeEmulator
{
	Idx = -1;

	function __readData()
	{
		if (this.Data.len() <= ++this.Idx)
		{
			::logError(format("Tried to read data beyond (%i) the length (%i) of the Deserialization Emulator", this.Idx, this.Data.len()));
			return null;
		}
		return this.Data[this.Idx];
	}

	function readString()
	{
		return this.__readData();
	}

	function __readInt()
	{
		return this.__readData();
	}

	function __readFloat()
	{
		return this.__readData();
	}

	function readBool()
	{
		return this.__readData();
	}

	function readI32()
	{
		return this.__readInt();
	}

	function readU32()
	{
		return this.__readInt();
	}

	function readI16()
	{
		return this.__readInt();
	}

	function readU16()
	{
		return this.__readInt();
	}

	function readI8()
	{
		return this.__readInt();
	}

	function readU8()
	{
		return this.__readInt();
	}

	function readF32()
	{
		return this.__readFloat();
	}

	function getFromFlagContainer( _flags ) // doesn't check if flags exist
	{
		local startString = this.getEmulatorString();
		this.Data = array(_flags.get(startString));
		for (local i = 0; i < this.Data.len(); ++i)
		{
			if (_flags.has(startString + "." + i))
			{
				local value = _flags.get(startString + "." + i)
				this.Data[i] = value;
			}
		}
	}
}

::runTest <- function()
{
	local test = { Hi = 123, Bye = "No", Taro = true, Midas = 420.69}; // make a dummy table
	::MSU.Mod.Serialization.flagSerialize("test", test) // save the table in mod_msu.test
	local test1 = ::MSU.Mod.Serialization.flagDeserialize("test") // load the table from mod_msu.test
	foreach (key, value in test)
	{
		assert(test1[key] == value); // assert the tables are equal
	}
	::MSU.System.Serialization.clearFlags(); // clear the flags made by the table
	local emulatorString = ::MSU.Class.SerDeEmulator(::MSU.Mod, "test").getEmulatorString();
	assert(!::World.Flags.has(emulatorString));
	for (local i = 0; i < test.len(); ++i)
	{
		assert(!::World.Flags.has(emulatorString + "." + i));
	}
	// make sure they are gone

	local bro = ::World.getPlayerRoster().getAll()[0]; // grab the first bro in our player roster
	local outEmulator = ::MSU.Class.SerializationEmulator(::MSU.Mod, "testBro");
	bro.onSerialize(outEmulator); // save the bro in the SerializationEmulator
	outEmulator.storeInFlagContainer(::World.Flags); // convert the SerializationEmulator into flags
	local inEmulator = ::MSU.Class.DeserializationEmulator(::MSU.Mod, "testBro");
	inEmulator.getFromFlagContainer(::World.Flags); // load the flags into the DeserialiationEmulator
	::newBro <- ::World.getTemporaryRoster().create("scripts/entity/tactical/player"); // create a dummy bro
	::newBro.onDeserialize(inEmulator); // deserialize the dummy bro to make him a clone of our original bro
	// now check manually that ::newBro is the same as ::World.getPlayerRoster().getAll()[0] because there's no (easy?) way to check which fields are serialized
	// Main issue I still have are that with this 2nd part there's no way to clear the flags created, but overall it seems to work flawlessly which (frankly) is fucking awesome.
}
