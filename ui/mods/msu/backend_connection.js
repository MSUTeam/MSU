var MSUBackendConnection = function ()
{
	this.mSQHandle = null;
};

MSUBackendConnection.prototype.isConnected = function ()
{
	return this.mSQHandle !== null;
};

MSUBackendConnection.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;
};

MSUBackendConnection.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;
};
