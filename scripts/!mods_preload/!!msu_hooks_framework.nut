local new = ::new;
::new = function( _script )
{
	local ret = new(_script);
	if (_script in ::MSU.Hooks.NewObjectHooks) ::MSU.Hooks.callHookCore(::MSU.Hooks.NewObjectHooks, _script, [this, ret]);
	return ret;
}

local inherit = ::inherit;
::inherit = function( _baseScript, _newTable )
{
	local currentScript = getstackinfos(2).src.slice(0, -4);
	// some people compile scripts incorrectly so the embedded path does not start with "scripts/". try to fix it. first, replace
	// backslashes with forward slashes and then chop off anything before the last "scripts/" within the path
	currentScript = ::String.replace(currentScript, "\\", "/");
	local i = -8; // 8 is the length of "scripts/"
	for(local j; (j = currentScript.find("scripts/", i+8)) != null; i = j) { }
	if(i > 0) currentScript = currentScript.slice(i);

	::MSU.Hooks.CurrentScriptStack.push(currentScript);

	if (currentScript in ::MSU.Hooks.ChangeParent) _baseScript = ::MSU.Hooks.ChangeParent[currentScript];

	local o = inherit(_baseScript, _newTable);

	// First hook the base class
	local super = o[o.SuperName];
	local superScript = ::IO.scriptFilenameByHash(super.ClassNameHash);
	if (superScript in ::MSU.Hooks.BaseClassHooks)
	{
		::MSU.Hooks.callHookCore(::MSU.Hooks.BaseClassHooks, superScript, [this, super]);
	}

	// Then hook this class itself
	::MSU.Hooks.callHookCore(::MSU.Hooks.ClassHooks, currentScript, [this, o]);

	// Then run hookChildren from its parent on this class
	if (_baseScript in ::MSU.Hooks.ChildrenHooks)
	{
		::MSU.Hooks.callHookCore(::MSU.Hooks.ChildrenHooks, _baseScript, [this, o]);
	}

	// Then run hookDescendants from all the parents on this class
	super = o;
	superScript = null;
	while ("SuperName" in super)
	{
		super = super[super.SuperName];
		superScript = ::IO.scriptFilenameByHash(super.ClassNameHash);
		if (superScript in ::MSU.Hooks.DescendantHooks)
		{
			::MSU.Hooks.callHookCore(::MSU.Hooks.DescendantHooks, superScript, [this, o]);
		}
	}

	::MSU.Hooks.CurrentScriptStack.pop();

	return o;
}

::MSU.Hooks <- {
	NewObjectHooks = {},
	ClassHooks = {},
	BaseClassHooks = {},
	ChildrenHooks = {},
	DescendantHooks = {},
	LeavesHooks = {},
	ChangeParent = {},
	CurrentScriptStack = [],

	function callHookCore( _hooks, _script, _args )
	{
		// ::logInfo("_callHookCore " + _script);
		if (!(_script in _hooks)) return;

		local hooksName = "";
		foreach (key, value in ::MSU.Hooks)
		{
			if (value == _hooks)
			{
				hooksName = key;
				break;
			}
		}
		// ::logInfo(format("%s: %s", hooksName, _script));

		foreach (func in _hooks[_script])
		{
			func.acall(_args);
		}
	}

	function addHookCore( _hooks, _script, _function )
	{
		if (!(_script in _hooks)) _hooks[_script] <- [_function];
		else _hooks[_script].push(_function);
	}

	function hookNewObject( _script, _function, _onceOnly = false )
	{
		this.addHookCore(this.NewObjectHooks, _script, _function);
	}

	function hookClass( _script, _function )
	{
		this.addHookCore(this.ClassHooks, _script, _function);
	}

	function hookBaseClass( _script, _function )
	{
		this.addHookCore(this.BaseClassHooks, _script, _function);
	}

	function hookChildren( _script, _function )
	{
		this.addHookCore(this.ChildrenHooks, _script, _function);
	}

	function hookDescendants( _script, _function )
	{
		this.addHookCore(this.DescendantHooks, _script, _function);
	}

	function hookLeaves( _script, _functionName, _function )
	{
		this.hookDescendants(_script, @(o) ::MSU.Hooks.hookLeafFunction(o, _functionName, _function));
	}

	function hookLeafFunction( o, _functionName, _function )
	{
		local oldFunc = _functionName in o ? o[_functionName] : null;
		local currentScript = ::MSU.Hooks.CurrentScriptStack.top();
		::logWarning(format("hookLeafFunction:: currentScript: %s", currentScript));

		// We hook every descendant assuming it is a "Leaf"
		if (!(currentScript in ::MSU.Hooks.LeavesHooks)) ::MSU.Hooks.LeavesHooks[currentScript] <- {};
		if (!(_functionName in ::MSU.Hooks.LeavesHooks[currentScript]))
		{
			::logInfo(format("Hooking %s in %s as Leaf with oldFunc: %s", _functionName, currentScript, oldFunc + ""));
			::MSU.Hooks.LeavesHooks[currentScript][_functionName] <- oldFunc;
		}

		// We go up the chain of inheritance to check if any of this guy's parents have been "leafed" as above
		// If yes, we revert the hooks on those, because we want this guy to be the leaf, obviously.
		local obj = o;
		while ("SuperName" in obj)
		{
			obj = obj[obj.SuperName];
			local parentScript = ::IO.scriptFilenameByHash(obj.ClassNameHash)
			if ((parentScript in ::MSU.Hooks.LeavesHooks) && (_functionName in ::MSU.Hooks.LeavesHooks[parentScript]))
			{
				local originalFunction = ::MSU.Hooks.LeavesHooks[parentScript][_functionName];
				if (originalFunction == null) obj.rawdelete(_functionName);
				else obj[_functionName] = originalFunction;
				::logInfo(format("Resetting Leaf hook on %s in %s to func: %s", _functionName, parentScript, originalFunction + ""));
			}
		}

		o[_functionName] <- _function(oldFunc);
	}

	function changeParent( _childScript, _newParentScript )
	{
		::MSU.Hooks.ChangeParent[_childScript] <- _newParentScript;
	}
}

// Testing:

// ::MSU.Hooks.hookClass("scripts/items/weapons/weapon", function(o) {
// 	::logInfo("hooked weapon");
// 	local onUpdateProperties = o.onUpdateProperties;
// 	o.onUpdateProperties = function( _properties )
// 	{
// 		::logInfo("weapon.nut onUpdateProperties");
// 		onUpdateProperties(_properties);
// 	}

// 	o.getID <- function()
// 	{
// 		::logInfo("weapon.nut getID: " + this.m.ID);
// 		this.item.getID();
// 	}
// });

// ::MSU.Hooks.hookBaseClass("scripts/items/item", function(o) {
// 	::logInfo("hooked item");
// 	local oldgetID = o.getID;
// 	o.getID = function()
// 	{
// 		::logInfo("item.nut getID: " + this.m.ID);
// 		return oldgetID();
// 	}
// });

// ::MSU.Hooks.hookDescendants("scripts/items/item", function(o) {
// 	local parentName = o.SuperName;
// 	::MSU.Hooks.hookLeafFunction(o, "onUpdateProperties", function( _oldFunc )
// 	{
// 		return function( _properties )
// 		{
// 			::logInfo("onUpdateProperties hook 1");
// 			if (_oldFunc != null) _oldFunc(_properties);
// 			else this[parentName].onUpdateProperties(_properties);
// 		}
// 	});
// });

// ::MSU.Hooks.hookDescendants("scripts/items/item", function(o) {
// 	local parentName = o.SuperName;
// 	::MSU.Hooks.hookLeafFunction(o, "onUpdateProperties", function( _oldFunc )
// 	{
// 		return function( _properties )
// 		{
// 			::logInfo("onUpdateProperties hook 2");
// 			if (_oldFunc != null) _oldFunc(_properties);
// 			else this[parentName].onUpdateProperties(_properties);
// 		}
// 	});
// });

// ::MSU.Hooks.hookDescendants("scripts/items/item", function(o) {
// 	local parentName = o.SuperName;
// 	::MSU.Hooks.hookLeafFunction(o, "getID", function( _oldFunc )
// 	{
// 		return function()
// 		{
// 			::logInfo("getID hook 1: parentName " + parentName + ", _oldFunc: " + _oldFunc);
// 			if (_oldFunc != null) _oldFunc();
// 			else this[parentName].getID();
// 		}
// 	});
// });

// // Shorthand method to hook leaves, but doesn't have access to `parentName`
// ::MSU.Hooks.hookLeaves("scripts/items/item", "getID", function( _oldFunc ) {
// 	return function()
// 	{
// 		if (_oldFunc != null) _oldFunc();
// 	}
// });
