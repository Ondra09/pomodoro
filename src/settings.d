module settings;

const string appName = "PomodoroD-Beta";

version(Windows)
{
	const string gladeFile = "C:/Users/e528738/Documents/GitHub/pomodoro/uidesign/Alpha.gtkbuilder";
	const string msgInputDialog = "C:/Users/e528738/Documents/GitHub/pomodoro/uidesign/msginputdialog.gtkbuilder";
	const string msgFileLocation = "."; // todo : create configuration for different windows brands
}else // linux
{
	const string gladeFile = "/Users/Ondra/Projects/pomodoro/uidesign/Alpha.gtkbuilder";
	const string msgInputDialog = "/Users/Ondra/Projects/pomodoro/uidesign/msginputdialog.gtkbuilder";

	const string msgFileLocation = "~/Library/Application Support/" ~ appName;

}
