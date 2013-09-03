module workdescription;

import std.json;
import std.stdio;

struct Message
{
	string message;
	void storeToDisk()
	{
		JSONValue rContainer;
		JSONValue message;
		JSONValue timestamp;

		message.type = JSON_TYPE.STRING;
		message.str = "Pomodoro -- JSON store implementation!";

		timestamp.type = JSON_TYPE.STRING;
		timestamp.str = "09.05.1023";

		rContainer.type = JSON_TYPE.OBJECT;
		rContainer.object["msg"]= message;

		rContainer.type = JSON_TYPE.OBJECT;
		rContainer.object["timestamp"]= timestamp;
		

		writeln(toJSON(&rContainer));

	}
};
