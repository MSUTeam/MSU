/*! (c) Andrea Giammarchi - ISC */
var self = this || {}; try { self.WeakMap = WeakMap } catch (t) { self.WeakMap = function (e, t) { "use strict"; var n = t.defineProperty, a = t.hasOwnProperty, i = r.prototype; return i.delete = function (t) { return this.has(t) && delete t[this._] }, i.get = function (t) { return this.has(t) ? t[this._] : void 0 }, i.has = function (t) { return a.call(t, this._) }, i.set = function (t, e) { return n(t, this._, { configurable: !0, value: e }), this }, r; function r(t) { n(this, "_", { value: "_@ungap/weakmap" + e++ }), t && t.forEach(s, this) } function s(t) { this.set(t[0], t[1]) } }(Math.random(), Object) }

MSU.Loc = {
	Languages : {
		English: 0,
		German: 1,
	},
	Language: 1,
	Simple: {},
	Complex: [],
	Translations: new WeakMap(),
	Originals: new WeakMap(),

	translateComplex: function (_match, _complexData)
	{
		var stringBuilder = _complexData.translation;
		// todo optimize into a single replace using $N and a complex regex
		// console.error("translateComplex")
		for (var i = 0; i < _complexData.recursives.length; ++i)
		{
			stringBuilder = stringBuilder.replace(new RegExp("\\{" + _complexData.recursives[i] + "\\*\\}", "g"), this.translate(_match[_complexData.recursives[i] + 1]))
		}
		for (var i = 0; i < _complexData.replacements.length; ++i)
		{
			stringBuilder = stringBuilder.replace(new RegExp("\\{" + _complexData.replacements[i] + "\\}", "g"), _match[_complexData.replacements[i] + 1])
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
		if (!_text.match(/^[\s\n]+$/g))
		{
			var xhr = new XMLHttpRequest();
			xhr.open("POST", "http://localhost:42069/post");
			xhr.setRequestHeader("Content-Type", "application/json");
			xhr.onreadystatechange = function() {
				if (xhr.readyState === XMLHttpRequest.DONE) {
					if (xhr.status === 200) {
						// console.error(xhr.responseText);
					} else {
						console.error("status: " + xhr.status)
						console.error("Translation missing for \"" + _text + "\"");
					}
				}
			};
			xhr.send(JSON.stringify({
				text: _text,
				language: MSU.Loc.Language
			}));
		}

		return _text
	},

	translateElement: function (_element)
	{
		var walker = document.createTreeWalker(_element, NodeFilter.SHOW_TEXT);
		var node;
		while (node = walker.nextNode())
		{
			var translation = this.Translations.get(node);
			if (translation == node.nodeValue)
				continue;
			var original = this.Originals.get(node);
			if (original !== undefined && original != node.nodeValue)
			{
				console.error("ERROR: TRANSLATION CHANGED ORIGINAL \"" + original + "\" MODIFIED \"" + node.nodeValue + "\"");
			}

			this.Originals.set(node, node.nodeValue);
			node.nodeValue = this.translate(node.nodeValue);
			this.Translations.set(node, node.nodeValue)
		}
	},

	convertBBCodeTranslatedElement: function (_element)
	{
		var child = _element.firstChild;
		var walker = document.createTreeWalker(child, NodeFilter.SHOW_TEXT);
		var node;
		while (node = walker.nextNode())
		{
			this.Translations.set(node, node.nodeValue);
		}

		for (var i = child.childNodes.length - 1; i >= 0; --i)
		{
			_element.insertBefore(child.childNodes[i], _element.firstChild);
		}

		_element.removeChild(child);
	},

	translateObject: function (_object)
	{
		var element = _object[0]
		if (element == undefined)
			return;
		var child = element.firstChild;
		if (child == undefined)
			return;
		if (child.className == "MSU_BBCODE_Translated")
		{
			this.convertBBCodeTranslatedElement(element);
			return;
		}
		this.translateElement(element);
	},

	addComplex: function (string, translation)
	{
		// if (string.startsWith("[p=c]"))
		var complex = {
			regex: new RegExp("^" + string.replace(/[.*+?^$()|[\]\\]/g, "\\$&").replace(/{\d+!}/g, "(\\d+)").replace(/{\d+\*?}/g, "(.+)") + "$"),
			recursives: [],
			replacements: [],
			translation: translation
		};
		if (string == null) {
			console.error(queryStackTrace())
		}
		string.match(/{\d+[\*!]?}/g).forEach(function (e) {
			if (e.charAt(e.length - 2) == '*')
				complex.recursives.push(parseInt(e.substring(1, e.length - 2)));
			else
				complex.replacements.push(parseInt(e.substring(1, e.length - 1)));
		});
		this.Complex.push(complex);
		// console.error("ADDED COMPLEX: " + JSON.stringify(this.Complex[this.Complex.length - 1]))
	},

	addSimple: function (string, translation)
	{
		this.Simple[string] = translation;
		// console.error("ADDED SIMPLE: " + string + " -> " + translation)
	}
}
