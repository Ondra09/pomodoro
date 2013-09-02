module pomodoro;

import gtk.Builder;
import gtk.Button;
import gtk.Main;
import gtk.Label;
import gtk.Widget;
import gtk.Window;

import gobject.Type;

import std.datetime;
import std.stdio;
import std.c.process;

import core.time;

import settings;

/**
 * 
 *
 */

int main(string[] args)
{
	string gladefile;
	auto currentTimeT = Clock.currTime();

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
		throw new Exception("Could not create Glade object from file.");
		exit(1);
	}

	Window w = cast(Window)g.getObject("Pomodoro");
	Label timerLabel;
	Button b;

	bool gladeLoadStatus = true;
	if (w !is null)
	{
		w.setTitle("This is a glade window");
		w.addOnHide( delegate void(Widget aux){ exit(0); } );

		b = cast(Button)g.getObject("button1");
		if (b !is null)
		{
			b.addOnClicked( delegate void(Button aux){ exit(0); } );
		}else
		{
			gladeLoadStatus = false;
		}

		timerLabel = cast(Label)g.getObject("label1");

		if (timerLabel !is null)
		{
			auto currentTime = Clock.currTime();
			
			timerLabel.setLabel((currentTime-currentTimeT).toString());
		}else
		{
			gladeLoadStatus = false;
		}
	}
	else
	{
		gladeLoadStatus = false;
	}

	if (!gladeLoadStatus)
	{
		throw new Exception("Glade file load failure.");
		exit(1);
	}

	w.showAll();
	Main.run();

	return 0;
}
