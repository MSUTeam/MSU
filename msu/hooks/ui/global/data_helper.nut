::MSU.MH.hook("scripts/ui/global/data_helper", function(q) {
	q.convertCampaignStoragesToUIData = @( __original ) function()
	{
		local queryStorages = ::PersistenceManager.queryStorages;
		::PersistenceManager.queryStorages = function()
		{
			return queryStorages().filter(@(_, _v) !::MSU.String.startsWith(_v.getFileName(), ::MSU.System.PersistentData.FilePrefix));
		}
		local ret = __original();
		::PersistenceManager.queryStorages = queryStorages;
		return ret;
	}
});

