MSU.Hooks.LoadCampaignMenuModule_addCampaignEntryToList = LoadCampaignMenuModule.prototype.addCampaignEntryToList;
LoadCampaignMenuModule.prototype.addCampaignEntryToList = function (_data)
{
	MSU.Hooks.LoadCampaignMenuModule_addCampaignEntryToList.call(this, _data);
	if (_data.isIncompatibleVersion && _data.MSU_ModIncompatibility.length !== 0)
	{
		var entry = this.mListScrollContainer.find('.ui-control.campaign:last');
		console.error("binding tooltip to " + entry);
		entry.bindTooltip({ contentType: "msu-generic", modId: MSU.ID, elementId: "LoadCampaign", errors: _data.MSU_ModIncompatibility})
	}
};
