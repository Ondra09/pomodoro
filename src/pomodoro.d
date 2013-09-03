module pomodoro;

import gtk.Builder;
import gtk.Main;

import gobject.Type;

import std.stdio;
import std.c.process;

import settings;
import uiload;

import workdescription;

/**
 * 
 *
 */

int main(string[] args)
{
	string gladefile;

	Main.init(args);

	if(args.length > 1)
	{
		writefln("Loading %s", args[1]);
		gladefile = args[1];
	}
	else
	{
		writeln("No glade file specified, using default:", gladeFile);
		gladefile = gladeFile;
	}

	Builder g = new Builder();

	if( ! g.addFromFile(gladefile) )
	{
		throw new Exception("Could notBUILD_DIRlade object from file.");
		exit(1);
	}

	UIHandlers uiItems;
	uiItems.loadUI(g);

	// test
	Message msg;
	msg.storeToDisk();

	Main.run();

	return 0;
}

