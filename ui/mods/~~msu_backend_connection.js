/*
 *  @Project:       Battle Brothers
 *  @Company:       Overhype Studios
 *
 *  @Copyright:     (c) Overhype Studios | 2013 - 2020
 * 
 *  @Author:        Overhype Studios
 *  @Date:          31.10.2017
 *  @Description:   World Town Screen JS
 */
"use strict";


var MSU = {}
var MSUBackendConnection = function(_parent)
{
    this.mSQHandle = null;
    SQ.call(Screens["MainMenuScreen"].mSQHandle, "setupJSConnection");
    SQ.call(this.mSQHandle, "connectScreens");
}


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


MSUBackendConnection.prototype.setCustomKeybinds = function(_keybinds)
{
    MSU.GlobalKeyHandler.AddHandlerFunction("2+shift", "testKeybind", function(_event){
        console.error("Testing keybind")
    })
    MSU.CustomKeybinds.setFromSQ(_keybinds);
}

registerScreen("MSUBackendConnection", new MSUBackendConnection());





