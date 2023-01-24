MSU.NestedTooltip = {
	__regexp : /{(\w+)}(.*?){\/\1}/gm,
	__tooltipStack : [],
	__tooltipRoot : null,
	__tooltipHideDelay : 200,
	bind : function (_element, _data)
	{
		var self = this;

		_element.on('mouseenter', function(_event)
		{
			console.error('mouseenter ori')
			Screens.TooltipScreen.mTooltipModule.notifyBackendQueryTooltipData(_data, function (_backendData)
			{
				self.createTooltip(_backendData, _element, _element.contentType);
			});
		});
		if (this.__tooltipRoot == null)
		{
			console.error('__tooltipRoot 2')
			_element.on('mouseenter', function(_event)
			{
				console.error('mouseenter root')
				_element.mouseIsOver = true;
				if (_element.msuTooltipTimeout !== null)
					clearTimeout(_element.msuTooltipTimeout);
			});
			_element.on('mouseleave', function (_event)
			{
				_element.msuTooltipTimeout = setTimeout(self.hideTooltip, self.__tooltipHideDelay, _element, self);
			});
			this.__tooltipRoot = _element;
		}
	},
	updateStack : function ()
	{
		var hoveringOver = null;
		for (var i = this.__tooltipStack.length - 1; i >= 0; i--)
		{
			if (this.__tooltipStack[i].mouseIsOver)
			{
				hoveringOver = i;
				break;
			}
		}
		if (hoveringOver == null)
		{
			if (this.__tooltipRoot != null && this.__tooltipRoot.mouseIsOver)
				hoveringOver = 1;
			else
			{
				hoveringOver = 0;
				this.__tooltipRoot = null;
			}
		}
		else
			++hoveringOver;
		console.error('hoveringOver ' + hoveringOver)
		for (var i = this.__tooltipStack.length - 1; i >= hoveringOver; --i)
		{
			this.__tooltipStack[i].remove();
			this.__tooltipStack.pop()
		}
	},
	hideTooltip : function (_element, _self)
	{
		_self == _self || this;
		_element.mouseIsOver = false;
		_self.updateStack();
	},
	createTooltip : function (_data, _parentElement, _contentType)
	{
		var container = this.getDivFromData(_data, _contentType);
		container.mouseIsOver = false;
		var self = this;
		this.__tooltipStack.push(container);
		var len = this.__tooltipStack.length;
		container.on('mouseenter', function (_event)
		{
			container.mouseIsOver = true;
			if (container.msuTooltipTimeout !== undefined)
				clearTimeout(container.msuTooltipTimeout);
		})
		container.on('mouseleave', function (_event)
		{
			container.msuTooltipTimeout = setTimeout(self.hideTooltip, self.__tooltipHideDelay, container, self);
		})

		$('body').append(container)
		this.positionTooltip(container, _data, _parentElement);
	},
	createEmptyTooltip : function ()
	{
		var tooltip = {
			container : $('<div class="tooltip-module ui-control-tooltip-module line"/>'),
			ornament : $('<div class="top-ornament"/>'),
			header : $('<div class="header-container"/>'),
			content : $('<div class="content-container"></div>'),
			leftContent : $('<div class="left-content-container"></div>'),
			rightContent : $('<div class="right-content-container"></div>'),
			footer : $('<div class="footer-container"></div>'),
			hint : $('<div class="hint-container"></div>')
		}
		tooltip.container.append(tooltip.ornament);
		tooltip.container.append(tooltip.header);
		tooltip.container.append(tooltip.content);
		tooltip.content.append(tooltip.leftContent);
		tooltip.content.append(tooltip.rightContent);
		tooltip.container.append(tooltip.footer);
		tooltip.container.append(tooltip.hint);
		return tooltip;
	},
	getDivFromData : function (_data, _contentType)
	{
		var tooltip = this.createEmptyTooltip();
		for (var i = 0; i < _data.length; ++i)
		{
			var data = _data[i];
			if ('contentType' in data)
				continue;
			if (typeof(data) != 'object' || !('type' in data))
			{
				queryStackTrace()
				throw 'ERROR: Failed to find "type" field while interpreting tooltip entry. Index: ' + i;
			}
			if (!('id' in data))
			{
				queryStackTrace()
				throw 'ERROR: Failed to find "id" field while interpreting tooltip entry. Index: ' + i;
			}

			var hasHeader = false;
			var hasHeaderText = false;
			var hasContent = false;
			var hasFooter = false;
			var hasHint = false;

			switch(data.type)
			{
				case 'title':
					if (Screens.TooltipScreen.mTooltipModule.addHeaderTitleDiv(tooltip.header, data) != null)
						hasHeader = true;
					break;
				case 'description':
					if (Screens.TooltipScreen.mTooltipModule.addHeaderDescriptionDiv(tooltip.header, data) != null)
						hasHeader = true;
					break;
				case 'header':
					if (Screens.TooltipScreen.mTooltipModule.addHeaderContentTextDiv(tooltip.rightContent, data) != null)
						hasContent = true;
					break;
				case 'headerText':
					if (Screens.TooltipScreen.mTooltipModule.addHeaderTextDiv(tooltip.header, data) != null)
					{
						hasHeader = true;
						hasHeaderText = true;
					}
					break;
				case 'image':
					if (Screens.TooltipScreen.mTooltipModule.addAtmosphericImageDiv(tooltip.leftContent, data) != null)
						hasContent = true;
					break;
				case 'text':
					if (Screens.TooltipScreen.mTooltipModule.addContentTextDiv(tooltip.rightContent, data) != null)
						hasContent = true;
					break;
				case 'progressbar':
					if (Screens.TooltipScreen.mTooltipModule.addContentProgressbarDiv(tooltip.rightContent, data) != null)
						hasContent = true;
					break;
				case 'icons':
					if (Screens.TooltipScreen.mTooltipModule.addFooterIconDiv(tooltip.footer, data) != null)
						hasFooter = true;
					break;
				case 'hint':
					if (Screens.TooltipScreen.mTooltipModule.addFooterIconDiv(tooltip.hint, data) != null)
						hasHint = true;
					break;
			}
			if (!hasHeaderText && !hasFooter)
				tooltip.header.addClass('display-none');
			if (!hasContent)
				tooltip.content.addClass('display-none');
			if (!hasFooter)
				tooltip.footer.addClass('display-none');
			if (!hasHint)
				tooltip.hint.addClass('display-none');

			switch(_contentType)
			{
				case 'tile':
					tooltip.container.addClass('is-full-width is-tile-content');
					break;
				case 'tile-entity':
				case 'entity':
					tooltip.container.addClass('is-entity-content');
					break;
				case 'roster-entity':
					tooltip.container.addClass('is-full-width is-entity-content');
					break;
				case 'skill':
					tooltip.container.addClass('is-full-width is-skill-content');
					break;
				case 'status-effect':
					tooltip.container.addClass('is-full-width is-status-effect-content');
					break;
				case 'settlement-status-effect':
					tooltip.container.addClass('is-full-width is-status-effect-content');
					break;
				case 'ui-element':
				case 'verbatim':
				case 'company-perk':
					tooltip.container.addClass('is-full-width is-ui-element-content');
					break;
				case 'ui-item':
					tooltip.container.addClass('is-full-width is-ui-item-content');
					break;
				case 'follower':
					tooltip.container.addClass('is-full-width is-ui-element-content');
					break;
			}

			if (hasContent || hasHeaderText)
			{
				var headerDescription = tooltip.header.find('> .row.description-container').last();
				var headerTitle = tooltip.header.find('> .row.title-container').last();
				if (headerDescription.length !== 0)
					headerDescription.addClass('ui-control-tooltip-module-bottom-devider');
				else if (headerTitle.length !== 0)
					headerTitle.addClass('ui-control-tooltip-module-bottom-devider');
			}

			if (hasContent && hasHeaderText)
			{
				var headerLastText = tooltip.header.find('> .row.title-text-container').last();
				headerLastText.addClass('ui-control-tooltip-module-bottom-devider');
			}

			if ((hasHeader || hasContent) && hasFooter)
			{
				tooltip.footer.addClass('ui-control-tooltip-module-top-devider');
			}

			if ((hasHeader || hasContent) && hasHint)
			{
				tooltip.hint.addClass('ui-control-tooltip-module-top-devider');
			}
		}
		tooltip.container.css('height', 100)
		return tooltip.container;
	},
	positionTooltip : function (_tooltip, _data, _targetDIV)
	{
		var tooltipModule = Screens.TooltipScreen.mTooltipModule;
		var offsetY = ('yOffset' in _data) ? _data.yOffset : tooltipModule.mDefaultYOffset;
		if (offsetY !== null)
		{
			if (typeof(offsetY) === 'string')
				offsetY = parseInt(offsetY, 10);
			else if (typeof(offsetY) !== 'number')
				offsetY = 0;
		}

		var targetOffset    = _targetDIV.offset();
		var elementWidth    = _targetDIV.outerWidth(true);
		var elementHeight   = _targetDIV.outerHeight(true);
		var containerWidth  = _tooltip.outerWidth(true);
		var containerHeight = _tooltip.outerHeight(true);

		var posLeft = (targetOffset.left + (elementWidth / 2)) - (containerWidth / 2);
		var posTop  = targetOffset.top - containerHeight - offsetY;

		if (posLeft < 0)
			posLeft = targetOffset.left;

		if (posLeft + containerWidth > $(window).width())
			posLeft = targetOffset.left + elementWidth - containerWidth;

		if (posTop < 0)
			posTop = targetOffset.top + elementHeight + offsetY;

		_tooltip.css({ left: posLeft, top: posTop });
		// _tooltip.velocity("finish", true).velocity({ opacity: 0.99 }, { duration: tooltipModule.mFadeInTime }); // Anti Alias Fix
	},
	parseText : function (_text)
	{
		return _text.replace(this.RegExp, function (_match, _id, _text)
		{
			return '<span class="msu-nested-tooltip" data-msu-nested-id="' + _id + '">' + _text + '</span>' // probably some formatting here
		})
	}
}
