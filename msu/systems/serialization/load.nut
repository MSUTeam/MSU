function includeFile( _file )
{
	::includeFile("msu/systems/serialization/", _file);
}
includeFile("metadata_emulator");
includeFile("serde_emulator");
includeFile("serialization_emulator");
includeFile("deserialization_emulator");

includeFile("serialization_system.nut");
::MSU.System.Serialization <- ::MSU.Class.SerializationSystem();
includeFile("serialization_mod_addon.nut");
