// enulates the _out object passed to onSerialize functions
::MSU.Class.SerializationEmulator <- class extends ::MSU.Class.SerDeEmulator
{
}

foreach (key, value in ::MSU.Class.SerDeEmulator.__WriteFields)
{
	::MSU.Class.SerializationEmulator[key] <- value;
}
