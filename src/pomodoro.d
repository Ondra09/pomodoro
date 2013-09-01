module pomodoro;

import gtk.Builder;
import gtk.Button;
import gtk.Main;
import gtk.Widget;
import gtk.Window;

import gobject.Type;

import std.stdio;
import std.c.process;

import settings;

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
		writefln("No glade file specified, using default \"builderTest.glade\"");
		gladefile = gladeFile;
	}

	Builder g = new Builder();

	if( ! g.addFromFile(gladefile) )
	{
		writefln("Oops, could not create Glade object, check your glade file ;)");
		exit(1);
	}

	Window w = cast(Window)g.getObject("Pomodoro");

	if (w !is null)
	{
		w.setTitle("This is a glade window");
		w.addOnHide( delegate void(Widget aux){ exit(0); } );

		Button b = cast(Button)g.getObject("button1");
		if(b !is null)
		{
			b.addOnClicked( delegate void(Button aux){ exit(0); } );
		}
	}
	else
	{
		writefln("No window?");
		exit(1);
	}

	w.showAll();
	Main.run();

	return 0;
}
