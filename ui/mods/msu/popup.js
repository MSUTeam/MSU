var MSUPopup = function ()
{
	this.mSQHandle = null
	this.mContainer = null;
	this.mSmallContainer = null;
	this.mParent = null;
	this.mID = "MSUPopup";

	this.mHeaderContainer = null;
	this.mContentContainer = null;
	this.mListScrollContainer = null;
	this.mFooterContainer = null;
	this.mTitle = null;
	this.mStates = {
		None : 0,
		Small : 1,
		Full : 2
	}
	this.mState = this.mStates.None;
	this.mLastState = this.mState;
	this.mNumModsChecked = null;
	this.mNumUpdates = null;
}

MSUPopup.prototype.onConnection = function (_handle)
{
	this.register($('.root-screen'));
	this.mSQHandle = _handle;
}

MSUPopup.prototype.createDIV = function (_parentDiv)
{
	var self = this;
	this.mContainer = $('<div class="msu-popup ui-control dialog display-none opacity-none"/>');
	_parentDiv.append(this.mContainer);
	this.mContainer.click(function(){
		self.toggleState();
	})

	this.mHeaderContainer = $('<div class="header"/>');
	this.mContainer.append(this.mHeaderContainer);

	this.mTitle = $('<div class="title title-font-very-big font-bold font-bottom-shadow font-color-title">Mod Error</div>');
	this.mHeaderContainer.append(this.mTitle);

	this.mListContainer = this.mContainer.createList(1, 'content-container');
	this.mListScrollContainer = this.mListContainer.findListScrollContainer();
	this.mContainer.append(this.mContentContainer);


	this.mFooterContainer = $('<div class="footer"/>')
	this.mContainer.append(this.mFooterContainer);

	this.mFooterContainer.createTextButton("Ok", function()
	{
		self.hide();
	}, "ok-button", 1);

	this.mFooterContainer.find(".ok-button:first").on("force-quit", function()
	{
		$(this).findButtonText().html("Quit Game");
		$(this).on("click", function()
		{
			self.quitGame();
		})
	})
}

MSUPopup.prototype.createSmallDIV = function (_parentDiv)
{
	var self = this;
	this.mSmallContainer = $('<div class="msu-popup-small"/>');
	_parentDiv.append(this.mSmallContainer);
	this.mModUpdateButton = $('<div class="msu-popup-small-update-button"/>')
		.appendTo(this.mSmallContainer)
		.on("click", function(){
			self.toggleState();
	})
	this.mModUpdateInfo = $('<div class="msu-popup-small-update-info"/>')
		.appendTo(this.mSmallContainer)
}

MSUPopup.prototype.create = function(_parentDiv)
{
	this.createDIV(_parentDiv);
	this.createSmallDIV(_parentDiv);
};

MSUPopup.prototype.destroy = function ()
{
	this.destroyDIV();
	this.destroySmallDIV();
}

MSUPopup.prototype.destroySmallDIV = function ()
{
	this.mSmallContainer.empty();
	this.mSmallContainer.remove();
	this.mSmallContainer = null;
}

MSUPopup.prototype.show = function ()
{
	var self = this;
	// MSUUIScreen.show
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
			self.notifyBackendOnAnimating();
			$(this).removeClass('display-none').addClass('display-block');
		},
		complete: function ()
		{
			self.notifyBackendOnShown();
		}
	});
}

MSUPopup.prototype.setState = function (_state)
{
	this.mState = _state;
	if (this.mState == this.mStates.Small)
	{
		this.mContainer.hide();
		this.mSmallContainer.show();
	}
	else
	{
		this.mContainer.show();
		this.mSmallContainer.hide();
		this.show();
	}
}

MSUPopup.prototype.toggleState = function ()
{
	this.setState(this.mState == this.mStates.Small ? this.mStates.Full : this.mStates.Small);
}

MSUPopup.prototype.isVisible = function ()
{
	return this.mContainer.css('display') == "block" || this.mSmallContainer.css('display') == "block";
}

MSUPopup.prototype.showRawText = function (_data)
{
	if (_data.forceQuit)
	{
		this.mTitle.text("Fatal Mod Error");
		this.mFooterContainer.find(".ok-button:first").trigger('force-quit')
	}
	else
	{
		this.mTitle.text("Mod Error");
	}
	this.mListScrollContainer.append($('<div class="mod-raw-text">' + _data.text + '</div>'));
	if (!this.isVisible())
	{
		this.setState(this.mStates.Full);
	}
}

MSUPopup.prototype.showModUpdates = function (_mods)
{
	this.mTitle.text("Mod Updates Available");
	var self = this;
	$.each(_mods, function (_key, _modInfo)
	{
		var modInfoContainer = $('<div class="msu-mod-info-container"/>');
		self.mListScrollContainer.append(modInfoContainer)
		modInfoContainer.append($('<div class="mod-name title title-font-big font-bold font-color-title">' + _modInfo.name + '</div>'));

		if ("GitHub" in _modInfo.sources)
		{
			var githubContainer = $('<div class="l-github-button"/>');
			modInfoContainer.append(githubContainer);
			var githubButton = githubContainer.createImageButton(Path.GFX + "mods/msu/logos/github-32.png", function ()
			{
				openURL(_modInfo.sources.GitHub);
			});
		}
		if ("NexusMods" in _modInfo.sources)
		{
			var nexusModsContainer = $('<div class="l-nexusmods-button"/>');
			modInfoContainer.append(nexusModsContainer);
			nexusModsContainer.createImageButton(Path.GFX + "mods/msu/logos/nexusmods-32.png", function ()
			{
				openURL(_modInfo.sources.NexusMods);
			});
		}

		var colorFromIdx = 0;
		if (_modInfo.updateType != "MAJOR")
		{
			colorFromIdx = _modInfo.availableVersion.indexOf('.') + 1;
		}
		if (_modInfo.updateType == "PATCH")
		{
			colorFromIdx = _modInfo.availableVersion.indexOf('.', colorFromIdx + 1) + 1;
		}
		var start = _modInfo.availableVersion.slice(0, colorFromIdx);
		var coloredSpan = '<span style="color:red;">' + _modInfo.availableVersion.slice(colorFromIdx) + '</span>';
		modInfoContainer.append($('<div class="version-info text-font-normal">' + _modInfo.currentVersion + ' => ' + start + coloredSpan + ' (Update Available)</div>'));
	});
	var checkText = "" + this.mNumModsChecked + (this.mNumModsChecked == 1 ? " mod" : " mods") + " checked<br>";
	checkText += this.mNumUpdates + (this.mNumUpdates == 1 ? " update" : " updates");
	this.mModUpdateInfo.html(checkText);
	this.setState(this.mStates.Small);
}

MSUPopup.prototype.hide = function ()
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
			self.notifyBackendOnHidden();
			$(this).css({ opacity: 0 });
			$(this).removeClass('display-block').addClass('display-none');
		}
	});
}

MSUPopup.prototype.register = function (_parentDiv)
{
	console.log('MSUPopup::REGISTER');
	this.create(_parentDiv);
}

MSUPopup.prototype.unregister = function ()
{
	console.log('MSUPopup::UNREGISTER');
	this.destroy();
}

MSUPopup.prototype.quitGame = function ()
{
	SQ.call(this.mSQHandle, "quitGame");
}

MSUPopup.prototype.notifyBackendOnShown = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenShown');
	}
};

MSUPopup.prototype.notifyBackendOnHidden = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenHidden');
	}
};

MSUPopup.prototype.notifyBackendOnAnimating = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenAnimating');
	}
};

registerScreen("MSUPopup", new MSUPopup());
