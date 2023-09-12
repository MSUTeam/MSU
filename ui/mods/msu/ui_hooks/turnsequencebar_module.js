TacticalScreenTurnSequenceBarModule.prototype.MSU_CanUpdateCostsPreview = false;

var updateCostsPreview = TacticalScreenTurnSequenceBarModule.prototype.updateCostsPreview;
TacticalScreenTurnSequenceBarModule.prototype.updateCostsPreview = function (_previewData)
{
	if (this.MSU_CanUpdateCostsPreview === true) updateCostsPreview.call(this, _previewData);
}

TacticalScreenTurnSequenceBarModule.prototype.MSU_setCanUpdateCostsPreview = function (_bool)
{
	this.MSU_CanUpdateCostsPreview = _bool;
}
