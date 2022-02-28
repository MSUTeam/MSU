"use strict";

var MSU = {}

var MSUConnection = function ()
{
	MSUBackendConnection.call(this);
}

MSUConnection.prototype = Object.create(MSUBackendConnection.prototype)
Object.defineProperty(MSUConnection.prototype, 'constructor', {
	value: MSUConnection,
	enumerable: false,
	writable: true });

MSUConnection.prototype.setCustomKeybinds = function (_keybinds)
{
	MSU.GlobalKeyHandler.AddHandlerFunction("2+shift", "testKeybind", function(_event){
		console.error("Testing keybind")
	})
	MSU.CustomKeybinds.setFromSQ(_keybinds);
	//test
}

registerScreen("MSUConnection", new MSUConnection());
