
namespace BlizzardApi.Global
{
    using System;
    using WidgetInterfaces;

    public static partial class Global
    {
        /// <summary>
        /// Execute a console command.
        /// </summary>
        /// <param name="command"></param>
        public static void ConsoleExec(string command) { throw new NotImplementedException(); }
        /// <summary>
        /// Attempts to detect the world of warcraft MMO mouse.
        /// </summary>
        public static void DetectWowMouse() { throw new NotImplementedException(); }
        /// <summary>
        /// Returns information about current client build.
        /// </summary>
        /// <returns></returns>
        public static Tuple<string, string, string, double> GetBuildInfo() { throw new NotImplementedException(); }
        /// <summary>
        /// Returns the currently set error handler.
        /// </summary>
        /// <returns></returns>
        public static Action geterrorhandler() { throw new NotImplementedException(); }
        public static IFrame GetCurrentKeyBoardFocus() { throw new NotImplementedException(); } // Returns the [editbox] widget currently handling keyboard events.
        public static string GetExistingLocales() { throw new NotImplementedException(); } // Returns a list of installed language packs.
        public static double GetFramerate() { throw new NotImplementedException(); } // Returns the current framerate (full precision)
        public static Tuple<int, int> GetGameTime() { throw new NotImplementedException(); } // Returns the time in-game.
        public static string GetLocale() { throw new NotImplementedException(); } // Returns client locale, example 'enUS'.
        public static Tuple<double, double> GetCursorPosition() { throw new NotImplementedException(); } // Returns the cursor's position on the screen.
        public static Tuple<double, double, double, double> GetNetStats() { throw new NotImplementedException(); } // Get bandwidth and latency network information.
        public static string GetRealmName() { throw new NotImplementedException(); } // returns the name of the server a user is logged in to
        public static int GetScreenHeight() { throw new NotImplementedException(); } // Returns the height of the window in pixels.
        public static int GetScreenWidth() { throw new NotImplementedException(); } // Returns the width of the window in pixels.
        public static string GetText(string identifier) { throw new NotImplementedException(); } // Used to localize some client text.
        public static double GetTime() { throw new NotImplementedException(); } // Returns the system uptime in seconds (millisecond precision).
        public static bool IsAltKeyDown() { throw new NotImplementedException(); } // Returns true if the alt key is currently depressed.
        public static bool InCinematic() { throw new NotImplementedException(); }
        public static bool IsControlKeyDown() { throw new NotImplementedException(); } // Returns true if the control key is currently depressed.
        public static bool IsDebugBuild() { throw new NotImplementedException(); }
        public static bool IsDesaturateSupported() { throw new NotImplementedException(); }
        public static bool IsLeftAltKeyDown() { throw new NotImplementedException(); } // Returns true if the left alt key is currently depressed.
        public static bool IsLeftControlKeyDown() { throw new NotImplementedException(); } // Returns true if the left control key is currently depressed.
        public static bool IsLeftShiftKeyDown() { throw new NotImplementedException(); } // Returns true if the left shift key is currently depressed.
        public static bool IsLinuxClient() { throw new NotImplementedException(); } // Boolean - Returns true if WoW is being run on Linux.
        public static bool IsLoggedIn() { throw new NotImplementedException(); } // Returns nil before the PLAYER_LOGIN event has fired, 1 afterwards.
        public static bool IsMacClient() { throw new NotImplementedException(); } // Returns true if WoW is being run on Mac.
        public static bool IsRightAltKeyDown() { throw new NotImplementedException(); } // Returns true if the right alt key is currently depressed.
        public static bool IsRightControlKeyDown() { throw new NotImplementedException(); } // Returns true if the right control key is currently depressed.
        public static bool IsRightShiftKeyDown() { throw new NotImplementedException(); } // Returns true if the right shift key is currently depressed.
        public static bool IsShiftKeyDown() { throw new NotImplementedException(); } // Returns true if the shift key is currently depressed.
        public static bool IsStereoVideoAvailable() { throw new NotImplementedException(); } // (added 3.0.8)
        public static bool IsWindowsClient() { throw new NotImplementedException(); } // Returns true if WoW is being run on Windows.
        public static bool OpeningCinematic() { throw new NotImplementedException(); } // Shows the opening movie for a player's race
        public static void PlayMusic(string path) { throw new NotImplementedException(); } // Plays the specified mp3.
        public static void PlaySound(string sound, string channel) { throw new NotImplementedException(); } // Plays the specified built-in sound effect.
        public static void PlaySoundFile(string path) { throw new NotImplementedException(); } // Plays the specified sound file.
        public static void ReloadUI() { throw new NotImplementedException(); } // Reloads the UI from source files
        public static void RepopMe() { throw new NotImplementedException(); } // The "Release Spirit" button. Sends you to the graveyard when dead.
        public static void RequestTimePlayed() { throw new NotImplementedException(); } // Request a summary of time played from the server.
        public static void RestartGx() { throw new NotImplementedException(); } // Restarts the graphical engine. Needed for things such as resolution changes to take effect.
        public static void RunScript(string script) { throw new NotImplementedException(); } // Execute "script" as a block of Lua code.
        public static void Screenshot() { throw new NotImplementedException(); } // Takes a screenshot.
        public static string SecondsToTime(double seconds) { throw new NotImplementedException(); } // Converts a number of seconds into a readable days / hours / etc. formatted string.
        public static string SecondsToTime(double seconds, bool noSeconds) { throw new NotImplementedException(); } // Converts a number of seconds into a readable days / hours / etc. formatted string.
        public static void SetAutoDeclineGuildInvites(int value) { throw new NotImplementedException(); } // Set the checkbox option for blocking guild invites (value may be 0 or 1)
        public static void seterrorhandler(Action function) { throw new NotImplementedException(); } // Set the error handler to the given parameter.
        public static void StopCinematic() { throw new NotImplementedException(); }
        public static void StopMusic() { throw new NotImplementedException(); } // Stops the currently playing mp3.
        public static bool UIParentLoadAddOn(string AddOnName) { throw new NotImplementedException(); } // Loads or Reloads the specified AddOn, and pops up an error message if it fails to load for any reason.
        public static bool UIParentLoadAddOn(int index) { throw new NotImplementedException(); } // Loads or Reloads the specified AddOn, and pops up an error message if it fails to load for any reason.
        public static void TakeScreenshot() { throw new NotImplementedException(); } // Takes a screenshot.
        public static void ERRORMESSAGE(string value) { throw new NotImplementedException(); } // Displays the script error dialog with optional text
        public static void debuginfo() { throw new NotImplementedException(); } // Output win32 debug text. Freeware debug message viewer: DebugView (Has no effect on live server.)
        public static void message(string text) { throw new NotImplementedException(); } // Displays a message box with your text message and an "Okay" button.
    }
}
