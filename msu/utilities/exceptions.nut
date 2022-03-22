::MSU.Exception <- {
	KeyNotFound = function( _string = "" ) { return format("Key \'%s\' not found", _string.tostring()); },
	NotConnected = "The screen does not have a JSHandle (make sure you connect your screens)",
	AlreadyInState = "Trying to show already visible screen or hide an invisible one",
	InvalidType = function( _string = "" ) { return format("The variable \'%s\' is of the wrong type", _string.tostring()); },
	NotSemanticVersion = "Version not formatted according to Semantic Versioning guidelines (see https://semver.org/)",
	DuplicateKey = function( _string = "" ) { return format("The key \'%s\' is already present", _string.tostring()); },
	ModNotRegistered = "Register your mod with a system before trying to interact with it"
};
