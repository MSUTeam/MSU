var notifyBackendQueryTooltipData = TooltipModule.prototype.notifyBackendQueryTooltipData;
TooltipModule.prototype.notifyBackendQueryTooltipData = function (_data, _callback)
{
	notifyBackendQueryTooltipData.call(this, _data, _callback);
	if (this.mSQHandle === null)
	{
		return;
	}

	if (_data === null)
	{
		console.error('ERROR: Failed to query data from backend. Reason: Data was null.');
		return;
	}
	if ('contentType' in _data && _data.contentType == "msu-generic")
	{
		SQ.call(this.mSQHandle, 'onQueryGenericTooltipData', _data, _callback);
	}
}
