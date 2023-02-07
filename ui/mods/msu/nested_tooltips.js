MSU.NestedTooltip = {
	__regexp : /(?:\[|&#91;)tooltip=([\w\.]+?)\.([\w\.\+]+)(?:\]|&#93;)(.*?)(?:\[|&#91;)\/tooltip(?:\]|&#93;)/gm,
	__tooltipStack : [],
	__tooltipHideDelay : 200,
	__tooltipShowDelay : 200,
	bindToElement : function (_element, _data)
	KeyImgMap : {},
	TileTooltipDiv : {
		container : $("<div class='msu-tile-div'/>").appendTo($(document.body)),
		expand : function(_newPosition)
		{
			this.container.show();
			this.container.offset(_newPosition);
		},
		shrink : function()
		{
			var sourceData = this.container.data("msu-nested");
			if (sourceData !== undefined && sourceData !== null)
			{
				var tooltipData = sourceData.tooltipContainer.data("msu-nested");
				if (tooltipData !== undefined && tooltipData.isLocked)
				{
					return false;
				}
				MSU.NestedTooltip.clearTimeouts(sourceData);
				sourceData.isHovered = false;
				MSU.NestedTooltip.updateStack();
			}
			this.container.hide();
			return true;
		},
		bind : function(_params)
		{
			MSU.NestedTooltip.bindToElement(this.container, _params);
		},
		unbind : function()
		{
			MSU.NestedTooltip.unbindFromElement(this.container);
		},
		trigger : function()
		{
			this.container.trigger('mouseenter.msu-tooltip-source');
		}
	},
	reloadTooltip : function(_element, _newParams)
	{
		if (this.__tooltipStack.length === 0)
			return;
		var sourceData = this.__tooltipStack[0].source;
		var sourceContainer = sourceData.container;
		var sourceParams = sourceData.tooltipParams;
		if (_element !== undefined && !_element.is(sourceContainer))
			return;
		this.clearStack();
		this.unbindFromElement(sourceContainer);
		this.bindToElement(sourceContainer, _newParams || sourceParams);
		sourceContainer.trigger('mouseenter.msu-tooltip-source');
	},
	{
		_element.on('mouseenter.msu-tooltip-source', this.getBindFunction(_data));
	},
	unbindFromElement : function (_element)
	{
		var data = _element.data('msu-nested');
		if (data !== undefined)
		{
			data.isHovered = false;
			this.updateStack();
		}
		_element.off('.msu-tooltip-source');
	},
	getBindFunction : function (_tooltipParams)
	{
		return function (_event)
		{
			var self = MSU.NestedTooltip;
			var tooltipSource = $(this);
			if (tooltipSource.data('msu-nested') !== undefined) return;
			var createTooltipTimeout = setTimeout(function(){
				self.onShowTooltipTimerExpired(tooltipSource, _tooltipParams);
			}, self.__tooltipShowDelay);

			tooltipSource.on('mouseleave.msu-tooltip-loading', function (_event)
			{
				clearTimeout(createTooltipTimeout);
				tooltipSource.off('mouseleave.msu-tooltip-loading');
			})

		}
	},
	onShowTooltipTimerExpired : function(_sourceContainer, _tooltipParams)
	{
		var self = this;
		_sourceContainer.off('.msu-tooltip-loading');
		// ghetto clone to get new ref
		_tooltipParams = JSON.parse(JSON.stringify(_tooltipParams));

		if (this.__tooltipStack.length > 0)
		{
			// check if this is within the same chain of nested tooltips, or if we need to clear the stack and start a new chain
			if (this.__tooltipStack[this.__tooltipStack.length -1].tooltip.container.find(_sourceContainer).length === 0)
			{
				self.clearStack();
			}
			// If we already have tooltips in the stack, we want to fetch the one from the first tooltip that will have received the entityId from the vanilla function
			else
			{
				$.each(this.__tooltipStack[0].dataToPass, function(_key, _value)
				{
					if (_key in _tooltipParams)
						return;
					_tooltipParams[_key] = _value;
				})
			}
		}
		Screens.TooltipScreen.mTooltipModule.notifyBackendQueryTooltipData(_tooltipParams, function (_backendData)
		{
			if (_backendData === undefined || _backendData === null)
		    {
		    	self.TileTooltipDiv.shrink();
		        return;
		    }

		    // vanilla behavior, when sth moved into tile while the data was being fetched
		    if (_tooltipParams.contentType === 'tile' || _tooltipParams.contentType === 'tile-entity')
		    	Screens.TooltipScreen.mTooltipModule.updateContentType(_backendData)

			self.createTooltip(_backendData, _sourceContainer, _tooltipParams);
		});
	},
	updateStack : function ()
	{
		for (var i = this.__tooltipStack.length - 1; i >= 0; i--)
		{
			var pairData = this.__tooltipStack[i];
			if ((pairData.source.isHovered && pairData.source.container.is(":visible")) || (pairData.tooltip.isHovered && pairData.tooltip.container.is(":visible")))
				return;
			this.removeTooltip(pairData, i);
		}
	},
	clearStack : function ()
	{
		for (var i = this.__tooltipStack.length - 1; i >= 0; i--)
		{
			this.removeTooltip(this.__tooltipStack[i]);
		}
	},
	isStackEmpty : function ()
	{
		return this.__tooltipStack.length === 0;
	},
	removeTooltip : function (_pairData)
	{
		this.cleanSourceContainer(_pairData.source.container);
		this.cleanTooltipContainer(_pairData.tooltip.container);
		this.__tooltipStack.pop();
	},
	cleanSourceContainer : function(_sourceContainer)
	{
		_sourceContainer.off('.msu-tooltip-showing');
		var data = _sourceContainer.data("msu-nested");
		if (data === undefined)
			return;
		this.clearTimeouts(data);
		_sourceContainer.removeData('msu-nested');
	},
	cleanTooltipContainer : function(_tooltipContainer)
	{
		var data = _tooltipContainer.data("msu-nested");
		this.clearTimeouts(data);
		_tooltipContainer.remove();
	},
	createTooltip : function (_backendData, _sourceContainer, _tooltipParams)
	{
		var self = this;
		var tooltipContainer = this.getTooltipFromData(_backendData, _tooltipParams.contentType);
		var sourceData = {
			container : _sourceContainer,
			updateStackTimeout : null,
			isHovered : true,
			tooltipContainer : tooltipContainer,
			tooltipParams : _tooltipParams
		};
		_sourceContainer.data('msu-nested', sourceData);
		var tooltipData = {
			container : tooltipContainer,
			updateStackTimeout : null,
			isHovered : false,
			isLocked : false,
			sourceContainer : _sourceContainer
		};

		tooltipContainer.data('msu-nested', tooltipData);
		var stackData = {
			source : sourceData,
			tooltip : tooltipData
		}

		// Add data that we'll want to pass to any nested tooltips, such as entityId
		if (this.__tooltipStack.length == 0)
		{
			var dataToPass = {};
			$.each(_tooltipParams, function(_key, _value)
			{
				if (_key === "contentType" || _key === "elementId")
					return;
				dataToPass[_key] = _value;
			})
			stackData.dataToPass = dataToPass;
		}
		this.__tooltipStack.push(stackData);

		this.addTooltipLockHandler(tooltipContainer, _sourceContainer);

		this.addSourceContainerMouseHandler(_sourceContainer);

		this.addTooltipContainerMouseHandler(tooltipContainer);

		$('body').append(tooltipContainer)
		this.positionTooltip(tooltipContainer, _backendData, _sourceContainer);
	addTooltipLockHandler : function(_tooltipContainer, _sourceContainer)
	{
		var nestedItems = _tooltipContainer.find(".msu-nested-tooltip");
		if (nestedItems.length == 0)
			return;
		var self = this;

		_tooltipContainer.addClass("msu-nested-tooltips-within");
		var progressImage = $("<div class='tooltip-progress-bar'/>")
			.appendTo(_tooltipContainer)

		progressImage.velocity({ opacity: 0 },
		{
	        duration: 1000,
			begin: function()
			{
				progressImage.css("opacity", 1)
	        },
			complete: function()
			{
				progressImage.remove();
				var data = _tooltipContainer.data('msu-nested');
				if (data === undefined)
				{
					return;
				}
				data.isLocked = true;
				_tooltipContainer.addClass("msu-nested-tooltips-locked");
				setTimeout(function()
				{
					_tooltipContainer.removeClass("msu-nested-tooltips-locked");
				}, 100)
	        }
	   });

		_sourceContainer.mousedown(function(){
			if (MSU.Keybinds.isMousebindPressed(MSU.ID, "LockTooltip"))
			{
				progressImage.velocity("finish");
			}
		})
	},
		});
		container.on('mouseenter.msu-tooltip-tooltip', function (_event)
		{
			var data = $(this).data('msu-nested');
			data.isHovered = true;
			if (data.timeout !== null)
			{
				clearTimeout(data.timeout);
				data.timeout = null;
			}
		});
		container.on('mouseleave.msu-tooltip-tooltip', function (_event)
		{
			var data = $(this).data('msu-nested');
			data.isHovered = false;
			data.timeout = setTimeout(self.updateStack.bind(self), self.__tooltipHideDelay);
		});

		$('body').append(container)
		this.positionTooltip(container, _data, _sourceElement);
	},
	getTooltipFromData : function (_data, _contentType)
	clearTimeouts : function(_data)
	{
		if (_data.updateStackTimeout !== undefined && _data.updateStackTimeout !== null)
		{
			clearTimeout(_data.updateStackTimeout);
			_data.updateStackTimeout = null;
		}
	},
	{
		var tempContainer = Screens.TooltipScreen.mTooltipModule.mContainer;
		var ret = $('<div class="tooltip-module ui-control-tooltip-module"/>');
		Screens.TooltipScreen.mTooltipModule.mContainer = ret;
		Screens.TooltipScreen.mTooltipModule.buildFromData(_data, false, _contentType);
		this.parseImgPaths(ret);
		Screens.TooltipScreen.mTooltipModule.mContainer = tempContainer;
		return ret;
	},
	positionTooltip : function (_tooltip, _backendData, _targetDIV)
	{
		var tempContainer = Screens.TooltipScreen.mTooltipModule.mContainer;
		Screens.TooltipScreen.mTooltipModule.mContainer = _tooltip;
		if (_targetDIV.is(this.TileTooltipDiv.container))
		{
			Screens.TooltipScreen.mTooltipModule.setupTileTooltip();
		}
		else
		{
			Screens.TooltipScreen.mTooltipModule.setupUITooltip(_targetDIV, _backendData);
		}
		Screens.TooltipScreen.mTooltipModule.mContainer = tempContainer;
	},
	getTooltipLinkHTML : function (_mod, _id, _text)
	{
		_text = _text || "";
		return '<div class="msu-nested-tooltip" data-msu-nested-mod="' + _mod + '" data-msu-nested-id="' + _id + '">' + _text + '</div>';
	},
	parseText : function (_text)
	{
		var self = this;
		return _text.replace(this.__regexp, function (_match, _mod, _id, _text)
		{
			return self.getTooltipLinkHTML(_mod, _id, _text);
		})
	},
	parseImgPaths : function (_jqueryObj)
	{
		var self = this;
		_jqueryObj.find('img').each(function ()
		{
			if (this.src in self.KeyImgMap)
			{
				var entry = self.KeyImgMap[this.src];
				var img = $(this);
				var div = $(self.getTooltipLinkHTML(entry.mod, entry.id));
				img.after(div);
				div.append(img.detach());
			}
		})
	}
}
MSU.XBBCODE_process = XBBCODE.process;
// I hate this but the XBBCODE plugin doesn't allow dynamically adding tags
// there's a fork that does here https://github.com/patorjk/Extendible-BBCode-Parser
// but we'd have to tweak it a bunch to add the vanilla tags
// it also changes some other stuff and is somewhat out of date at this point
// then again, the one used in vanilla is probably even more outdated
XBBCODE.process = function (config)
{
	var ret = MSU.XBBCODE_process.call(this, config);
	ret.html = MSU.NestedTooltip.parseText(ret.html)
	return ret;
}

$.fn.bindTooltip = function (_data)
{
	MSU.NestedTooltip.bindToElement(this, _data);
};

$.fn.unbindTooltip = function ()
{
	MSU.NestedTooltip.unbindFromElement(this);
};

$(document).on('mouseenter.msu-tooltip-source', '.msu-nested-tooltip', function()
{
	var data = {
		contentType : 'msu-nested-tooltip',
		elementId : this.dataset.msuNestedId,
		modId : this.dataset.msuNestedMod
	}
	MSU.NestedTooltip.getBindFunction(data).call(this);
})

TooltipModule.prototype.showTileTooltip = function()
{
	if (this.mCurrentData === undefined || this.mCurrentData === null)
	{
		return;
	}
	MSU.NestedTooltip.TileTooltipDiv.expand({top: this.mLastMouseY - 30, left:this.mLastMouseX - 30});
	MSU.NestedTooltip.updateStack();
	if (MSU.NestedTooltip.isStackEmpty())
	{
		MSU.NestedTooltip.TileTooltipDiv.bind(this.mCurrentData);
		MSU.NestedTooltip.TileTooltipDiv.trigger();
	}
};

MSU.TooltipModule_hideTileTooltip = TooltipModule.prototype.hideTileTooltip;
TooltipModule.prototype.hideTileTooltip = function()
{
	if (MSU.NestedTooltip.TileTooltipDiv.shrink())
		MSU.NestedTooltip.TileTooltipDiv.unbind();
	MSU.TooltipModule_hideTileTooltip.call(this);
};

$.fn.updateTooltip = function (_newParams)
{
    if (Screens.Tooltip === null || !Screens.Tooltip.isConnected())
    {
        return;
    }

    var tooltip = Screens.Tooltip.getModule('TooltipModule');
    if (tooltip !== null)
    {
        MSU.NestedTooltip.reloadTooltip(this, _newParams);
	}
};

TooltipModule.prototype.reloadTooltip = function()
{
	MSU.NestedTooltip.reloadTooltip();
};
