MSU.Hooks.TacticalScreenTurnSequenceBarModule_updateEntitySkillsPreview = TacticalScreenTurnSequenceBarModule.prototype.updateEntitySkillsPreview;
TacticalScreenTurnSequenceBarModule.prototype.updateEntitySkillsPreview = function (_entityId)
{
	var notifyBackendQueryEntitySkills = this.notifyBackendQueryEntitySkills;
	var self = this;
	this.notifyBackendQueryEntitySkills = function (_entityId, _callback) {
		notifyBackendQueryEntitySkills.call(this, _entityId, function (entitySkills) {
			_callback.call(self, entitySkills);
			if (entitySkills === null || !jQuery.isArray(entitySkills) || entitySkills.length === 0)
			{
				console.error('ERROR: Failed to query entity skills data for entity (' + _entityId + '). Reason: Invalid result.');
				return;
			}

			var skillsIdToDivMap = {};
			self.mSkillsContainer.find('.skill').each(function (index, element) {
				var skillDiv = $(element);
				var skill = skillDiv.data('skill');
				if (skill !== null && 'skillId' in skill) {
					var overlayImg = skillDiv.find('.overlay-layer img').filter(':first');
					if (overlayImg.length === 0)
						return;
					skillsIdToDivMap[skill.skillId] = { div: skillDiv, overlayImg: overlayImg, index: index };
				}
			});

			for (var i = 0; i < entitySkills.length; ++i)
			{
				var skillDivInfo = skillsIdToDivMap[entitySkills[i].id];
				if (skillDivInfo === undefined)
					continue;
				if (entitySkills[i].isUsable)
				{
					skillDivInfo.overlayImg.attr('src', Path.GFX + Asset.IMAGE_SKILL_NOT_USABLE);
				}
				else
				{
					if (entitySkills[i].isAffordable)
					{
						skillDivInfo.overlayImg.attr('src', Path.GFX + '/mods/msu/images/skill_affordable_overlay.png');
						skillDivInfo.overlayImg.velocity("finish", true).velocity({ opacity: 1 }, { duration: self.mSkillPreviewFadeIn });
					}
				}
			}
		});
	}
	MSU.Hooks.TacticalScreenTurnSequenceBarModule_updateEntitySkillsPreview.call(this, _entityId);
	this.notifyBackendQueryEntitySkills = notifyBackendQueryEntitySkills;
}
