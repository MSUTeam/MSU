::MSU.Class.Tooltip <- class
{
	Title = null;
	Text = null;

	constructor(_title, _text)
	{
		this.setTitle(_title);
		this.setText(_text);
	}

	function setTitle(_title)
	{
		::MSU.requireOneFromTypes(["string", "function"], _title);
		this.Title = typeof _title == "string" ? @() _title : _title;
	}

	function setText(_text)
	{
		::MSU.requireOneFromTypes(["string", "function"], _text);
		this.Text = typeof _text == "string" ? @() _text : _text;
	}

	function getTitle()
	{
		return this.Title();
	}

	function getText()
	{
		return this.Text();
	}

	function getUIData()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getTitle()
			},
			{
				id = 2,
				type = "description",
				text = this.getText()
			},
		];
		return ret;
	}
}
