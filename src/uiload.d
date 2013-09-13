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
import gtk.Entry;
import gtk.Label;
import gtk.Timeout;
import gtk.Widget;
import gtk.Window;

import workdescription;

immutable Duration workDuration = dur!"minutes"(25);
immutable Duration shortBreakDuration = dur!"minutes"(1);
immutable Duration longBreakDuration = dur!"minutes"(15);

struct UIHandlers
{
private:

	// TODO : create separat class for every dialog -- only if there will be more of them
	// main window
	Window w;
	
	Label timerLabel;
	Button buttonWork;
	Button buttonShort;
	Button buttonLong;

	// msg dialog
	Window msgWindow;
	Button okButton;
	Button cancelButton;
	Entry msgEntry;

	Duration wholeDuration;
	SysTime timerStartTick;
	bool countingDown = false;

public:

	void loadUI(ref Builder g)
	{
		w = cast(Window)g.getObject("Pomodoro");

		msgWindow = cast(Window)g.getObject("msginputwindow");

		msgWindow.setTransientFor(w);
		msgWindow.setModal(true);

		bool gladeLoadStatus = true;

		if (w !is null)
		{
			w.setTitle("This is a glade window");
			w.addOnHide( delegate void(Widget aux){ exit(0); } );

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

			// msg input buttons
			okButton = cast(Button)g.getObject("okbutton");
			if (okButton !is null)
			{
				okButton.addOnClicked( &msgInputOkPressed );
			}else
			{
				gladeLoadStatus = false;
			}

			cancelButton = cast(Button)g.getObject("cancelbutton");
			if (cancelButton !is null)
			{
				cancelButton.addOnClicked( &msgInputCancelPressed );
			}else
			{
				gladeLoadStatus = false;
			}

			msgEntry = cast(Entry)g.getObject("msgEntry");
			if (cancelButton !is null)
			{
				//cancelButton.addOnClicked( &msgInputCancelPressed );
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
				// show red label
				// ∞∞timerLabel.
			}
		}

		return true;
	}

	void workPressed(Button aux)
	{
		msgWindow.showAll();
	}

	void shortBreakPressed(Button aux)
	{
		initTimers(shortBreakDuration);
	}

	void longBreakPressed(Button aux)
	{
		initTimers(longBreakDuration);
	}

	// msg input dialog
	void msgInputOkPressed(Button aux)
	{
		msgWindow.hide();
		string pomodoroDescr = msgEntry.getText();
		// test
		workdescription.Message msg;
		msg.messageText = pomodoroDescr;
		msg.storeToDisk();

		initTimers(workDuration);
	}

	void msgInputCancelPressed(Button aux)
	{
		msgWindow.hide();
	}

	void initTimers(in ref Duration duration)
	{
		wholeDuration = duration;
		countingDown = true;
		timerStartTick = Clock.currTime();
	}
};
