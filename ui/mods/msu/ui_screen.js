var MSUUIScreen = function ()
{
	MSUBackendConnection.call(this);
	this.mEventListener = null;
	this.mContainer = null;
	this.mPopupDialog = null;
	this.mID = "MSUUIScreen";
};

MSUUIScreen.prototype = Object.create(MSUBackendConnection.prototype);
Object.defineProperty(MSUUIScreen.prototype, 'constructor', {
	value: MSUUIScreen,
	enumerable: false,
	writable: true
});

MSUUIScreen.prototype.registerEventListener = function (_listener)
{
	this.mEventListener = _listener;
};

MSUUIScreen.prototype.onConnection = function (_handle, _parentDiv)
{
	_parentDiv = _parentDiv || $('.root-screen');
    this.mSQHandle = _handle;
    this.register(_parentDiv);
};

MSUUIScreen.prototype.onDisconnection = function ()
{
    this.mSQHandle = null;
    this.unregister();
};

MSUUIScreen.prototype.createDIV = function (_parentDiv)
{

};

MSUUIScreen.prototype.destroyDIV = function ()
{
	this.mContainer.empty();
	this.mContainer.remove();
	this.mContainer = null;
};

MSUUIScreen.prototype.bindTooltips = function ()
{

};

MSUUIScreen.prototype.unbindTooltips = function ()
{

};

MSUUIScreen.prototype.show = function (_moveLeftRight, _considerParent)
{
	var self = this;
	var moveTo = { opacity: 1};
	var offset = -this.mContainer.width();
	if (_moveLeftRight === true)
	{
		moveTo = { opacity: 1, left: '0', right: '0' };
		var offset = -(this.mContainer.width());
		if (_considerParent === true && this.mContainer.parent() !== null && this.mContainer.parent() !== undefined)
		{
			offset -= this.mContainer.parent().width()
		}
		this.mContainer.css('left', offset);
	}
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
	this.onShow();
};

MSUUIScreen.prototype.hide = function (_moveLeftRight, _considerParent)
{
	var self = this;
	var moveTo = { opacity: 0};
	var offset = -this.mContainer.width();
	if (_moveLeftRight === true)
	{
		var offset = -(this.mContainer.width());
		if (_considerParent === true && this.mContainer.parent() !== null && this.mContainer.parent() !== undefined)
		{
			offset -= this.mContainer.parent().width()
		}
		moveTo["left"] = offset;
	}
	this.mContainer.velocity("finish", true).velocity(moveTo,
	{
		duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
		easing: 'swing',
		begin: function()
		{
			self.notifyBackendOnAnimating();
		},
		complete: function()
		{
			$(this).removeClass('display-block').addClass('display-none');
			self.notifyBackendOnHidden();
		}
	});
	this.onHide();
};

MSUUIScreen.prototype.onShow = function()
{
};

MSUUIScreen.prototype.onHide = function()
{
};


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

};

MSUUIScreen.prototype.setPopupDialog = function ( _dialog )
{
	this.mPopupDialog = _dialog;
	this.notifyBackendPopupVisible(true);
};

MSUUIScreen.prototype.destroyPopupDialog = function ()
{
	if(this.mPopupDialog !== null)
	{
		this.mPopupDialog.destroyPopupDialog();
		this.mPopupDialog = null;
	}
	this.notifyBackendPopupVisible(false);
};

MSUUIScreen.prototype.notifyBackendPopupVisible = function ( _data )
{
	SQ.call(this.mSQHandle, 'onPopupVisible', _data);
};

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
};

MSUUIScreen.prototype.notifyBackendOnAnimating = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenAnimating');
	}
};
