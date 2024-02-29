MSU.Loc = {
	Languages : {
		English: 0,
		German: 1,
	},
	Language: 1,
	Simple: {},
	Complex: [],
	Logged: {},

	translateComplex: function (_match, _complexData)
	{
		var stringBuilder = _complexData.translation;
		// todo optimize into a single replace using $N
		console.error("translateComplex")
		for (var i = 0; i < _complexData.positionMap.length; ++i)
		{
			stringBuilder = stringBuilder.replace("{" + _complexData.positionMap[i] + "}", _match[_complexData.positionMap[i] + 1])
		}
		return stringBuilder;
	},

	translate: function (_text)
	{
		if (this.Language == 0)
			return _text;
		if (_text in this.Simple)
			return this.Simple[_text];
		for (var i = this.Complex.length - 1; i >= 0; --i)
		{
			var match = _text.match(this.Complex[i].regex)
			if (match != null)
			{
				return this.translateComplex(match, this.Complex[i]);
			}
		}
		if (!(_text in this.Logged))
		{
			console.error("Translation missing for " + _text);
			this.Logged[_text] = null;
		}

		return _text
	},

	addComplex: function (string, translation)
	{
		this.Complex.push({
			regex: new RegExp("^" + string.replace(/{\d+}/g, "(.+)") + "$"),
			// regex: new RegExp("^(" + string.replace(/{\d+}/, ")(.+)(") + ")$"), // necessary to 'easily' extract the idx of an arbitrary group
			positionMap: string.match(/{\d+}/g).map(function (e) {
				return parseInt(e.substring(1, e.length - 1));
			}), // is often probably redundant, simple optimization would be to remove this if the matches are incremental
			translation: translation
		})
		console.error("ADDED COMPLEX: " + JSON.stringify(this.Complex[this.Complex.length - 1]))
	},

	addSimple: function (string, translation)
	{
		this.Simple[string] = translation;
		console.error("ADDED SIMPLE: " + string + " -> " + translation)
	}
}
