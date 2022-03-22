local function getInQuotes( _string )
{
	return typeof _string != "string" || _string.len() > 0 ? " \'" + _string.tostring() + "\'") : _string.tostring();
}

::MSU.Exception <- {
	KeyNotFound = function( _string ) { return format("Key%s not found", getinQuotes(_string)); },
	NotConnected = function( _string = "" ) { return format("The screen%s does not have a JSHandle (make sure you connect your screens)", getInQuotes(_string)); },
	AlreadyInState = function( _string = "" ) { return format("Trying to show already visible screen%s or hide an invisible one", getinQuotes(_string)); },
	InvalidType = function( _string = "" ) { return format("The variable%s is of the wrong type", getInQuotes(_string)); },
	NotSemanticVersion = function( _string = "" ) { return format("Version%s not formatted according to Semantic Versioning guidelines (see https://semver.org/)", getInQuotes(_string)); },
	DuplicateKey = function( _string ) { return format("The key%s is already present", getInQuotes(_string)); },
	ModNotRegistered = function( _string = "" ) { return format("Register your mod%s with a system before trying to interact with it", getInQuotes(_string)); }
};
