
namespace BlizzardApi.Global
{
    using System;
    using CsLuaFramework.Wrapping;
    using WidgetInterfaces;

    public partial interface IApi
    {
        /// <summary>
        /// Execute a console command.
        /// </summary>
        /// <param name="command"></param>
        void ConsoleExec(string command);
        /// <summary>
        /// Attempts to detect the world of warcraft MMO mouse.
        /// </summary>
        void DetectWowMouse();
        /// <summary>
        /// Returns information about current client build.
        /// </summary>
        /// <returns></returns>
        IMultipleValues<string, string, string, double> GetBuildInfo();
        /// <summary>
        /// Returns the currently set error handler.
        /// </summary>
        /// <returns></returns>
        Action geterrorhandler();
        IFrame GetCurrentKeyBoardFocus(); // Returns the [editbox] widget currently handling keyboard events.
        string GetExistingLocales(); // Returns a list of installed language packs.
        double GetFramerate(); // Returns the current framerate (full precision)
        IMultipleValues<int, int> GetGameTime(); // Returns the time in-game.
        string GetLocale(); // Returns client locale, example 'enUS'.
        IMultipleValues<double, double> GetCursorPosition(); // Returns the cursor's position on the screen.
        IMultipleValues<double, double, double, double> GetNetStats(); // Get bandwidth and latency network information.
        string GetRealmName(); // returns the name of the server a user is logged in to
        int GetScreenHeight(); // Returns the height of the window in pixels.
        int GetScreenWidth(); // Returns the width of the window in pixels.
        string GetText(string identifier); // Used to localize some client text.
        double GetTime(); // Returns the system uptime in seconds (millisecond precision).
        bool IsAltKeyDown(); // Returns true if the alt key is currently depressed.
        bool InCinematic();
        bool IsControlKeyDown(); // Returns true if the control key is currently depressed.
        bool IsDebugBuild();
        bool IsDesaturateSupported();
        bool IsLeftAltKeyDown(); // Returns true if the left alt key is currently depressed.
        bool IsLeftControlKeyDown(); // Returns true if the left control key is currently depressed.
        bool IsLeftShiftKeyDown(); // Returns true if the left shift key is currently depressed.
        bool IsLinuxClient(); // Boolean - Returns true if WoW is being run on Linux.
        bool IsLoggedIn(); // Returns nil before the PLAYER_LOGIN event has fired, 1 afterwards.
        bool IsMacClient(); // Returns true if WoW is being run on Mac.
        bool IsRightAltKeyDown(); // Returns true if the right alt key is currently depressed.
        bool IsRightControlKeyDown(); // Returns true if the right control key is currently depressed.
        bool IsRightShiftKeyDown(); // Returns true if the right shift key is currently depressed.
        bool IsShiftKeyDown(); // Returns true if the shift key is currently depressed.
        bool IsStereoVideoAvailable(); // (added 3.0.8)
        bool IsWindowsClient(); // Returns true if WoW is being run on Windows.
        bool OpeningCinematic(); // Shows the opening movie for a player's race
        void PlayMusic(string path); // Plays the specified mp3.
        void PlaySound(string sound, string channel); // Plays the specified built-in sound effect.
        void PlaySoundFile(string path); // Plays the specified sound file.
        void ReloadUI(); // Reloads the UI from source files
        void RepopMe(); // The "Release Spirit" button. Sends you to the graveyard when dead.
        void RequestTimePlayed(); // Request a summary of time played from the server.
        void RestartGx(); // Restarts the graphical engine. Needed for things such as resolution changes to take effect.
        void RunScript(string script); // Execute "script" as a block of Lua code.
        void Screenshot(); // Takes a screenshot.
        string SecondsToTime(double seconds); // Converts a number of seconds into a readable days / hours / etc. formatted string.
        string SecondsToTime(double seconds, bool noSeconds); // Converts a number of seconds into a readable days / hours / etc. formatted string.
        void SetAutoDeclineGuildInvites(int value); // Set the checkbox option for blocking guild invites (value may be 0 or 1)
        void seterrorhandler(Action function); // Set the error handler to the given parameter.
        void StopCinematic();
        void StopMusic(); // Stops the currently playing mp3.
        bool UIParentLoadAddOn(string AddOnName); // Loads or Reloads the specified AddOn, and pops up an error message if it fails to load for any reason.
        bool UIParentLoadAddOn(int index); // Loads or Reloads the specified AddOn, and pops up an error message if it fails to load for any reason.
        void TakeScreenshot(); // Takes a screenshot.
        void ERRORMESSAGE(string value); // Displays the script error dialog with optional text
        void debuginfo(); // Output win32 debug text. Freeware debug message viewer: DebugView (Has no effect on live server.)
        void message(string text); // Displays a message box with your text message and an "Okay" button.
    }
}
