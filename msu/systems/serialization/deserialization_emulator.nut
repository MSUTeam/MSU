// enulates the _in object passed to onDeserialize functions
::MSU.Class.DeserializationEmulator <- class extends ::MSU.Class.SerDeEmulator
{
}

foreach (key, value in ::MSU.Class.SerDeEmulator.__ReadFunctions)
{
	::MSU.Class.DeserializationEmulator[key] <- value;
}
