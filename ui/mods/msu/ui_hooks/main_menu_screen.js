MainMenuScreen.prototype.showMainMenuModule = function ()
{
	this.mMainMenuModule.show();
	MSU.Popup.setState(MSU.Popup.mLastState);
};

MainMenuScreen.prototype.hideMainMenuModule = function ()
{
	this.mMainMenuModule.hide();
	MSU.Popup.mLastState = MSU.Popup.mState;
	MSU.Popup.setState(MSU.Popup.mStates.None);
};

MainMenuScreen.prototype.hideNewCampaignModule = function ()
{
	this.mNewCampaignModule.hide();
};

MainMenuScreen.prototype.showNewCampaignModule = function ()
{
	this.mNewCampaignModule.show();
	this.mNewCampaignModule.mFirstPanel.removeClass('display-block').addClass('display-none');
	this.mNewCampaignModule.mSecondPanel.removeClass('display-block').addClass('display-none');
	this.mNewCampaignModule.mThirdPanel.addClass('display-block').removeClass('display-none');
	this.mNewCampaignModule.mCancelButton.changeButtonText("Previous");
	this.mNewCampaignModule.mStartButton.changeButtonText("Start");
};

MSU.Hooks.MainMenuScreen_hide = MainMenuScreen.prototype.hide;
MainMenuScreen.prototype.hide = function()
{
	MSU.Hooks.MainMenuScreen_hide.call(this);
	MSU.Popup.mLastState = MSU.Popup.mState;
	MSU.Popup.setState(MSU.Popup.mStates.None);
}

MSU.Hooks.MainMenuScreen_show = MainMenuScreen.prototype.show;
MainMenuScreen.prototype.show = function(_animate)
{
	MSU.Hooks.MainMenuScreen_show.call(this, _animate);
	MSU.Popup.setState(MSU.Popup.mLastState);
}

