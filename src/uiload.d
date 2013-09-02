module uiload;

import std.c.process;
import std.concurrency;
import std.datetime;
import std.stdio;

import core.thread;

import core.time;

import gtk.Builder;
import gtk.Button;
import gtk.Label;
import gtk.Widget;
import gtk.Window;
import gtk.Timeout;

struct UIHandlers
{
public:
	Window w;
	Label timerLabel;
	Button buttonWork;
	Button buttonShort;
	Button buttonLong;

	void loadUI(ref Builder g)
	{
		w = cast(Window)g.getObject("Pomodoro");

		bool gladeLoadStatus = true;

		if (w !is null)
		{
			w.setTitle("This is a glade window");
			import gtk.Timeout;w.addOnHide( delegate void(Widget aux){ exit(0); } );

			buttonWork = cast(Button)g.getObject("button1");
			if (buttonWork !is null)
			{
				buttonWork.addOnClicked( &workPressed ); // delegate void(Button aux){ exit(0); }
			}else
			{
				gladeLoadStatus = false;
			}

			buttonShort = cast(Button)g.getObject("button2");
			if (buttonShort !is null)
			{
				buttonShort.addOnClicked( &shortBrakePressed );
			}else
			{
				gladeLoadStatus = false;
			}

			buttonLong = cast(Button)g.getObject("button3");
			if (buttonLong !is null)
			{
				buttonLong.addOnClicked( &longBrakePressed );
			}else
			{
				gladeLoadStatus = false;
			}

			timerLabel = cast(Label)g.getObject("label1");

			if (timerLabel !is null)
			{
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
		}

		Timeout timeout = new Timeout( 1000, &onSecondElapsed, false );

		w.showAll();
	}

	bool onSecondElapsed()
	{
		auto currentTime = Clock.currTime();
		timerLabel.setLabel(currentTime.toISOExtString());

		return true;
	}

	void workPressed(Button aux)
	{
	}

	void shortBrakePressed(Button aux)
	{
	}

	void longBrakePressed(Button aux)
	{
	
	}

};
/*
void updateUI(shared Duration uiLabel)
{
	auto currentTime = Clock.currTime();
	//uiItems.timerLabel.setLabel((currentTime-currentTimeT).toString());
	//uiLabel.setLabel(currentTime.toISOExtString());

	Thread.sleep(dur!"msecs"(cast(long)(1000.0/13.0)));
}*/
