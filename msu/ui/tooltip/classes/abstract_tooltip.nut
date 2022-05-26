::MSU.Class.Tooltip <- class
{
	Title = null;
	Text = null;

	constructor(_title, _text)
	{
		::MSU.requireOneFromTypes(["string", "function"], _title, _text);
		this.Title = _title;
		this.Text = _text;
	}

	function getUIData()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = typeof this.Title == "string" ? this.Title : this.Title()
			},
			{
				id = 2,
				type = "description",
				text = typeof this.Text == "string" ? this.Text : this.Text()
			},
		];
		return ret;
	}
}
