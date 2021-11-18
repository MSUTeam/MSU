local gt = this.getroottable();
gt.MSU.defineThrowables <- function ()
{
	gt.Exception <- {
		KeyNotFound = "No such key in the Object",
		NotConnected = "The screen doesn't have a JSHandle (make sure you connect your screens)",
		AlreadyVisible = "Trying to show already visible screen",
		InvalidTypeException = "The variable is of the wrong type",
	};

	gt.Error <- {

	}
}