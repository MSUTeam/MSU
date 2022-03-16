::includeFile("msu/systems/serialization/", "serialization_system.nut");
::includeFile("msu/systems/serialization/", "serialization_mod_addon.nut");
this.MSU.System.Serialization <- this.MSU.Class.SerializationSystem();
::MSU.Mod.register(::MSU.System.Serialization);
