module pomodoro;

import gtk.Builder;
import gtk.Main;

import gobject.Type;

import std.stdio;
import std.c.process;

import settings;
import uiload;

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
		throw new Exception("Could not load glade object from file.");
		exit(1);
	}

	if( ! g.addFromFile(msgInputDialog) )
	{
		throw new Exception("Could not load glade object from file.");
		exit(1);
	}

	UIHandlers uiItems;
	uiItems.loadUI(g);

	Main.run();

	return 0;
}

