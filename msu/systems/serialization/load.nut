::includeFile("msu/systems/serialization/", "serialization_system.nut");
this.MSU.System.Serialization <- this.MSU.Class.SerializationSystem();
::includeFile("msu/systems/serialization/", "serialization_mod_addon.nut");
::MSU.Mod.register(::MSU.System.Serialization);
