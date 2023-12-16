// enulates the _out object passed to onSerialize functions
::MSU.Class.DebugSerdeEmulator <- class
{
	ReadWriter = null

	constructor(_r)
	{
		this.ReadWriter = _r;
	}

	function writeString( _string ) {::logConsole("writeString" + " " + _string); 	this.ReadWriter.writeString(_string)};
	function writeBool( _bool ) 	{::logConsole("writeBool" + " " + _bool); 		this.ReadWriter.writeBool(_bool)};
	function writeI32( _int ) 		{::logConsole("writeI32" + " " + _int); 		this.ReadWriter.writeI32(_int)};
	function writeU32( _int ) 		{::logConsole("writeU32" + " " + _int); 		this.ReadWriter.writeU32(_int)};
	function writeI16( _int ) 		{::logConsole("writeI16" + " " + _int); 		this.ReadWriter.writeI16(_int)};
	function writeU16( _int ) 		{::logConsole("writeU16" + " " + _int); 		this.ReadWriter.writeU16(_int)};
	function writeI8( _int ) 		{::logConsole("writeI8" + " " + _int); 			this.ReadWriter.writeI8(_int)};
	function writeU8( _int ) 		{::logConsole("writeU8" + " " + _int); 			this.ReadWriter.writeU8(_int)};
	function writeF32( _float ) 	{::logConsole("writeF32" + " " + _float); 		this.ReadWriter.writeF32(_float)};

	function readString() 			{local ret =  this.ReadWriter.readString(); ::logConsole("readString " + " " + ret);  	return ret;};
	function readBool() 			{local ret =  this.ReadWriter.readBool(); 	::logConsole("readBool " + " " + ret);  	return ret;};
	function readI32() 				{local ret =  this.ReadWriter.readI32(); 	::logConsole("readI32 " + " " + ret);  		return ret;};
	function readU32() 				{local ret =  this.ReadWriter.readU32(); 	::logConsole("readU32 " + " " + ret);  		return ret;};
	function readI16() 				{local ret =  this.ReadWriter.readI16(); 	::logConsole("readI16 " + " " + ret);  		return ret;};
	function readU16() 				{local ret =  this.ReadWriter.readU16(); 	::logConsole("readU16 " + " " + ret);  		return ret;};
	function readI8() 				{local ret =  this.ReadWriter.readI8(); 	::logConsole("readI8 " + " " + ret);  		return ret;};
	function readU8() 				{local ret =  this.ReadWriter.readU8(); 	::logConsole("readU8 " + " " + ret);  		return ret;};
	function readF32() 				{local ret =  this.ReadWriter.readF32(); 	::logConsole("readF32 " + " " + ret);  		return ret;};

	function beginRead()
	{
		this.ReadWriter.beginRead();
	}

	function endRead()
	{
		this.ReadWriter.endRead();
	}

	function beginWrite()
	{
		this.ReadWriter.beginWrite();
	}

	function endWrite()
	{
		this.ReadWriter.endWrite();
	}
}
