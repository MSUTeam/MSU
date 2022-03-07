this.MSU.UI <- {
	Connections = [],
	JSConnection = null,

	function registerConnection( _connection )
	{
		this.Connections.push(_connection);
	}

	function connect() // Want to make this call another function which acts as a very late time to run code, eg I want to lock the settingsmanager at this point (this runs after main menu load)
	{
		foreach (connection in this.Connections)
		{
			connection.connect();
		}
		this.MSU.UI.Connections.clear();
	}
}

