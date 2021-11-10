"use strict";

var MSUUIScreen = function ()
{
	this.mSQHandle = null;
	this.mEventListener = null;
	this.mContainer = null;

	this.mID = "MSUUIScreen"
}

MSUUIScreen.prototype.isConnected = function ()
{
	return this.mSQHandle !== null;
}

MSUUIScreen.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;

	// notify listener
	if (this.mEventListener !== null && ('onModuleOnConnectionCalled' in this.mEventListener))
    {
		this.mEventListener.onModuleOnConnectionCalled(this);
	}
};

MSUUIScreen.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;

	// notify listener
	if (this.mEventListener !== null && ('onModuleOnDisconnectionCalled' in this.mEventListener))
    {
		this.mEventListener.onModuleOnDisconnectionCalled(this);
	}
};

MSUUIScreen.prototype.registerEventListener = function (_listener)
{
	this.mEventListener = _listener;
};

MSUUIScreen.prototype.createDIV = function (_parentDiv)
{

}

MSUUIScreen.prototype.destroyDIV = function ()
{

}

MSUUIScreen.prototype.bindtooltips = function ()
{

}

MSUUIScreen.prototype.unbindtooltips = function ()
{

}

MSUUIScreen.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
};

MSUUIScreen.prototype.destroy = function()
{
    this.destroyDIV();
};

MSUUIScreen.prototype.register = function (_parentDiv)
{
    console.log(this.mID + '::REGISTER');

    if (this.mContainer !== null)
    {
        console.error("ERROR: Failed to register " + this.mID + ". Reason: " + this.mID + " is already initialized.");
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};


MSUUIScreen.prototype.unregister = function ()
{
    console.log(this.mID +'::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error("ERROR: Failed to unregister " + this.mID + ". Reason: " + this.mID + " is not initialized.");
        return;
    }

    this.destroy();
};

MSUUIScreen.prototype.isRegistered = function ()
{
	if (this.mContainer !== null)
	{
		return this.mContainer.parent().length !== 0;
	}

	return false;
};