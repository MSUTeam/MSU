"use strict";

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/setPrototypeOf#polyfill
// Allows for 'easy' inheritance:

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
};

MSUUIScreen.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;
};

MSUUIScreen.prototype.registerEventListener = function (_listener)
{
	this.mEventListener = _listener;
};

MSUUIScreen.prototype.createDIV = function (_parentDiv)
{
	this.mContainer = $('<div class="msu-screen dialog-screen ui-control display-none opacity-none"/>');
	_parentDiv.append(this.mContainer);
}

MSUUIScreen.prototype.destroyDIV = function ()
{
	this.mContainer.empty();
	this.mContainer.remove();
	this.mContainer = null;
}

MSUUIScreen.prototype.bindTooltips = function ()
{

}

MSUUIScreen.prototype.unbindTooltips = function ()
{

}

MSUUIScreen.prototype.show = function (_data)
{
	var self = this;
	var moveTo = { opacity: 1, right: '10.0rem' };
	var offset = -this.mContainer.width();
	if (self.mContainer.hasClass('is-center') === true)
	{
		moveTo = { opacity: 1, left: '0', right: '0' };
		offset = -(this.mContainer.parent().width() + this.mContainer.width());
		this.mContainer.css({ 'left': '0' });
	}

	this.mContainer.css({ 'right': offset });
	this.mContainer.velocity("finish", true).velocity(moveTo,
	{
		duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
		easing: 'swing',
		begin: function ()
		{
			$(this).removeClass('display-none').addClass('display-block');
			self.notifyBackendOnAnimating();
		},
		complete: function ()
		{
			self.mIsVisible = true;
			self.notifyBackendOnShown();
		}
	});
};

MSUUIScreen.prototype.hide = function ()
{
	var self = this;
	this.mContainer.velocity("finish", true).velocity({ opacity: 0 },
	{
		duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
		easing: 'swing',
		begin: function()
		{
			self.notifyBackendOnAnimating();
		},
		complete: function()
		{
			$(this).css({ opacity: 0 });
			$(this).removeClass('display-block').addClass('display-none');
			self.notifyBackendOnHidden();
		}
	});
}


MSUUIScreen.prototype.create = function(_parentDiv)
{
	this.createDIV(_parentDiv);
	this.bindTooltips();
};

MSUUIScreen.prototype.destroy = function()
{
	this.unbindTooltips();
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

MSUUIScreen.prototype.showBackgroundImage = function ()
{

}

//Notify backend Functions
MSUUIScreen.prototype.notifyBackendOnShown = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenShown');
	}
};

MSUUIScreen.prototype.notifyBackendOnHidden = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenHidden');
	}
}

MSUUIScreen.prototype.notifyBackendOnAnimating = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenAnimating');
	}
}


