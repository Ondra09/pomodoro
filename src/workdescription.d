module workdescription;

import std.datetime;
import std.json;
import std.stdio;
import std.path;
import std.file;

import settings;

struct Message
{
	string messageText;
//	SysTime timeOfAction = Clock.currTime();

	struct JsonMsg
	{
		JSONValue message;
		JSONValue timestamp;
	};

	void storeToDisk()
	{
		auto currentTime = Clock.currTime();
		string timestamp = currentTime.toISOExtString();

		string fileName = expandTilde(msgFileLocation)~"/work.csv";

		if (!exists(expandTilde(msgFileLocation)))
		{
			mkdirRecurse(expandTilde(msgFileLocation));
		}

		auto file = File(fileName, "a");
		file.write(timestamp~", ");
		file.write(messageText);
		file.write("\n");
		file.detach();
	}

	/// not supproted now, just thorw away json support for a while
	private void storeToDiskJSON()
	{
		JsonMsg newMsg;

		JSONValue rContainer;
		//timeOfAction.toISOExtString;
		with (newMsg)
		{
			message.type = JSON_TYPE.STRING;
			message.str = messageText;

			timestamp.type = JSON_TYPE.STRING;
			auto currentTime = Clock.currTime();
			timestamp.str = currentTime.toISOExtString();
		}

		rContainer.type = JSON_TYPE.OBJECT;
		rContainer.object["msg"]= newMsg.message;

		rContainer.type = JSON_TYPE.OBJECT;
		rContainer.object["started"]= newMsg.timestamp;

		string fileName = expandTilde(msgFileLocation)~"/work.json";

		// write file
		if (!exists(fileName))
		{
			mkdirRecurse(expandTilde(msgFileLocation));
		}

		//auto file = File(fileName, "r");
		////read whole old structure
		//file.read();
		//file.detach(); // will close if sole owner too

		auto file = File(fileName, "w");
		file.write(toJSON(&rContainer));
		file.detach();
	}
};
