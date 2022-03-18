MainMenuScreen.prototype.showMainMenuModule = function ()
{
	this.mMainMenuModule.show();
};

MainMenuScreen.prototype.hideMainMenuModule = function ()
{
	this.mMainMenuModule.hide();
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
