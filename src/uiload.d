module uiload;

import std.c.process;
import std.concurrency;
import std.conv;
import std.datetime;
import std.stdio;

import core.thread;

import core.time;

import gtk.Builder;
import gtk.Button;
import gtk.Label;
import gtk.Timeout;
import gtk.Widget;
import gtk.Window;

immutable Duration workDuration = dur!"minutes"(25);
immutable Duration shortBreakDuration = dur!"minutes"(1);
immutable Duration longBreakDuration = dur!"minutes"(15);

struct UIHandlers
{
private:

	Window w;
	Label timerLabel;
	Button buttonWork;
	Button buttonShort;
	Button buttonLong;

	Duration wholeDuration;
	SysTime timerStartTick;
	bool countingDown = false;

public:

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
				buttonShort.addOnClicked( &shortBreakPressed );
			}else
			{
				gladeLoadStatus = false;
			}

			buttonLong = cast(Button)g.getObject("button3");
			if (buttonLong !is null)
			{
				buttonLong.addOnClicked( &longBreakPressed );
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

		// lets do this 13 time per second to minitage problem with granularity
		Timeout timeout = new Timeout( 1000/13, &onSecondElapsed, false );

		w.showAll();
	}

private:
	bool onSecondElapsed()
	{
		if (countingDown)
		{
			auto currentTime = Clock.currTime();
			Duration timeToShow = (wholeDuration + (timerStartTick - currentTime));

			long minutes = timeToShow.get!"minutes"();
			long seconds = timeToShow.get!"seconds"();
			bool showMinus;

			if (seconds < 0)
			{
				seconds *= -1;
				minutes *= -1;

				showMinus = true;
			}

			string minutesLabel = to!(string)(minutes);
			string secondsLabel = (seconds<10?"0":"")~to!(string)(seconds);

			timerLabel.setLabel((showMinus?"-":"")~minutesLabel~":"~secondsLabel);

			if (showMinus)
			{
				//timerLabel.
			}
		}

		return true;
	}

	void workPressed(Button aux)
	{
		initTimers(workDuration);
	}

	void shortBreakPressed(Button aux)
	{
		initTimers(shortBreakDuration);
	}

	void longBreakPressed(Button aux)
	{
		initTimers(longBreakDuration);
	}

	void initTimers(in ref Duration duration)
	{
		wholeDuration = duration;
		countingDown = true;
		timerStartTick = Clock.currTime();
	}
};
