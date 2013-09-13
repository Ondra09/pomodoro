module uiload;

import std.c.process;
import std.concurrency;
import std.conv;
import std.datetime;
import std.json;
import std.stdio;
import std.path;
import std.file;

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
import settings;

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

	AppSettings appSetings;

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

		appSetings = new AppSettings();

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
		initTimers(appSetings.shortBreakDuration);
	}

	void longBreakPressed(Button aux)
	{
		initTimers(appSetings.longBreakDuration);
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

		initTimers(appSetings.workDuration);
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

class AppSettings
{
	immutable Duration workDuration;
	immutable Duration shortBreakDuration;
	immutable Duration longBreakDuration;

	this()
	{
		if (!exists(expandTilde(msgFileLocation)))
		{
			mkdirRecurse(expandTilde(msgFileLocation));
		}

		string fileName = expandTilde(msgFileLocation)~"/settings.json";

		if (!exists(fileName))
		{
			JSONValue rContainer;
			rContainer.type = JSON_TYPE.OBJECT;

			JSONValue shortBrake, longBrake, work;

			shortBrake.type = JSON_TYPE.INTEGER;
			longBrake.type = JSON_TYPE.INTEGER;
			work.type = JSON_TYPE.INTEGER;

			shortBrake.integer = 5;
			longBrake.integer = 20;
			work.integer = 25;

			rContainer.object["shortBreak"] = shortBrake;
			rContainer.object["longBreak"] = longBrake;
			rContainer.object["work"] = work;

			// create new one with standard settings
			auto file = File(fileName, "w");
			file.write(toJSON(&rContainer));
			file.detach();
		}
		
		// read settings from file
		auto file = File(fileName, "r");
		string fileCont;
		string buf;

		while(file.readln(buf))
		{
			fileCont ~= buf;
		}

		JSONValue rContainer = parseJSON(fileCont);

		JSONValue ssss = rContainer.object["work"];
		workDuration = dur!"minutes"(ssss.integer);

		ssss = rContainer.object["shortBreak"];
		shortBreakDuration = dur!"minutes"(ssss.integer);

		ssss = rContainer.object["longBreak"];
		longBreakDuration = dur!"minutes"(ssss.integer);

		file.detach();
	}
};
