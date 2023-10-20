::MSU.Sprite <- {
	SpriteOrder = {},

	function addSprite( _object, _sprite, _orderInfo, _native )
	{
		foreach (sprite in _orderInfo[_sprite].InFrontOf)
		{
			if (!_object.hasSprite(sprite))
				_object.addSprite(sprite);
		}

		// If the object already has the sprite that `addSprite` is trying to add then we fetch that
		// instead of adding it again. Necessary with this system because if someone changes order
		// of vanilla sprites, then this function may add those sprites to the entity
		// before a manual vanilla `addSprite` call to add that sprite.
		local ret = _object.hasSprite(_sprite) ? _object.getSprite(_sprite) : _native(_sprite);

		foreach (sprite in _orderInfo[_sprite].Behind)
		{
			if (!_object.hasSprite(sprite))
				_object.addSprite(sprite);
		}

		return ret;
	}

	function setOrder( _script, _sprite, _behind = null, _inFrontOf = null )
	{
		// Ensure that both _behind and _inFrontOf are not null at the same time.
		// And when not null, they are arrays.
		if (_behind != null) ::MSU.requireArray(_behind);
		else ::MSU.requireArray(_inFrontOf);
		if (_inFrontOf != null) ::MSU.requireArray(_inFrontOf);
		else ::MSU.requireArray(_behind);

		if (!(_script in this.SpriteOrder))
		{
			this.SpriteOrder[_script] <- {};
		}

		if (!(_sprite in this.SpriteOrder[_script]))
		{
			this.SpriteOrder[_script][_sprite] <- {
				Behind = [],
				InFrontOf = []
			};
		}

		if (_behind != null)
		{
			foreach (sprite in _behind)
			{
				if (this.SpriteOrder[_script][_sprite].Behind.find(sprite) == null)
					this.SpriteOrder[_script][_sprite].Behind.push(sprite);
			}
		}
		if (_inFrontOf != null)
		{
			foreach (sprite in _inFrontOf)
			{
				if (this.SpriteOrder[_script][_sprite].InFrontOf.find(sprite) == null)
					this.SpriteOrder[_script][_sprite].InFrontOf.push(sprite);
			}
		}
	}
}

::MSU.QueueBucket.VeryLate.push(function() {
	foreach (script, spriteOrder in ::MSU.Sprite.SpriteOrder)
	{
		local orderInfo = spriteOrder;
		::MSU.HooksMod.hook(script, function(q) {
			q.addSprite = @(__native) function( _sprite )
			{
				if (_sprite in orderInfo)
					return ::MSU.Sprite.addSprite(this, _sprite, orderInfo, __native);
				return __native(_sprite);
			}
		});
	}
	delete ::MSU.Sprite.SpriteOrder;
});
