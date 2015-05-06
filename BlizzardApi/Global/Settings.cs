
namespace BlizzardApi.Global
{
    using System;
    using MiscEnums;

    public static partial class Global
    {
        /// <summary>
        /// changes the entity for which COMBAT_TEXT_UPDATE events fire.
        /// </summary>
        /// <param name="unit">UnitId of the entity you want receive notifications for.</param>
        public static string CombatTextSetActiveUnit(UnitId unit) { throw new NotImplementedException(); }
        /// <summary>
        /// Download a backup of your settings from the server.
        /// </summary>
        public static void DownloadSettings() { throw new NotImplementedException(); }
        /// <summary>
        /// Returns the current value of a console variable.
        /// </summary>
        /// <param name="cVar">Name of the console variable</param>
        /// <returns></returns>
        public static object GetCVar(string cVar) { throw new NotImplementedException(); }
        /// <summary>
        /// Returns the default value of a console variable.
        /// </summary>
        /// <param name="cVar"></param>
        /// <returns></returns>
        public static object GetCVarDefault(string cVar) { throw new NotImplementedException(); } 
        /// <summary>
        /// Returns the value of the cvar as 1 or nil instead of requiring you to compare the cvar value with "0" or "1"
        /// </summary>
        /// <param name="cVar"></param>
        /// <returns></returns>
        public static bool GetCVarBool(string cVar) { throw new NotImplementedException(); } 
        /// <summary>
        /// returns name, defaultValue, serverStoredAccountWide, serverStoredPerCharacter
        /// </summary>
        /// <param name="cVar"></param>
        /// <returns></returns>
        public static Tuple<string, object, bool, bool> GetCVarInfo(string cVar) { throw new NotImplementedException(); } 
        /// <summary>
        /// Get the current in-use multi-sample (antialias) format.
        /// </summary>
        /// <returns></returns>
        public static int GetCurrentMultisampleFormat() { throw new NotImplementedException(); } 
        /// <summary>
        /// Get the index of the current screen resolution.
        /// </summary>
        /// <returns>This value will be the index of one of the values yielded by GetScreenResolutions()</returns>
        public static int GetCurrentResolution()  { throw new NotImplementedException(); } 
        public static double GetGamma() { throw new NotImplementedException(); }
        /// <summary>
        /// Get the available multi-sample (antialias) formats.
        /// </summary>
        /// <returns></returns>
        public static int GetMultisampleFormats() { throw new NotImplementedException(); } 
        /// <summary>
        /// Gets the refresh rate of a resolution.
        /// </summary>
        /// <param name="i">Index of the resolution you want to get the refresh rates for. Must be an index returned by GetScreenResolutions(). Passing nil defaults this argument to 1, the lowest resolution available.</param>
        /// <returns></returns>
        public static int GetRefreshRates(int i) { throw new NotImplementedException(); }
        /// <summary>
        /// Gets the refresh rate of the first resolution.
        /// </summary>
        /// <returns></returns>
        public static int GetRefreshRates() { throw new NotImplementedException(); }
        public static Tuple<string,string,string> GetScreenResolutions() { throw new NotImplementedException(); }
        public static object GetVideoCaps() { throw new NotImplementedException(); }
        /// <summary>
        /// returns whether threat warnings should currently be displayed.
        /// </summary>
        /// <returns></returns>
        public static bool IsThreatWarningEnabled() { throw new NotImplementedException(); } 
        /// <summary>
        /// Registers a variable for use with the #GetCVar and #SetCVar functions.
        /// </summary>
        /// <param name="cVar"></param>
        public static void RegisterCVar(string cVar) { throw new NotImplementedException(); } 
        /// <summary>
        /// Registers a variable for use with the #GetCVar and #SetCVar functions.
        /// </summary>
        /// <param name="cVar"></param>
        /// <param name="value"></param>
        public static void RegisterCVar(string cVar, object value) { throw new NotImplementedException(); } 
        public static void ResetPerformanceValues() { throw new NotImplementedException(); }
        public static void ResetTutorials() { throw new NotImplementedException(); }
        /// <summary>
        /// Set the value of a variable in config.wtf
        /// </summary>
        /// <param name="cVar"></param>
        /// <param name="value"></param>
        public static void SetCVar(string cVar, object value) { throw new NotImplementedException(); } 
        /// <summary>
        /// Set the value of a variable in config.wtf
        /// </summary>
        /// <param name="cVar"></param>
        /// <param name="value"></param>
        /// <param name="scriptCVar"></param>
        public static void SetCVar(string cVar, object value, string scriptCVar) { throw new NotImplementedException(); }
        /// <summary>
        /// Sets the decimal separator to a comma instead of a dot
        /// </summary>
        /// <param name="flag">enable</param>
        public static void SetEuropeanNumbers(bool flag) { throw new NotImplementedException(); } 
        public static void SetGamma(double value) { throw new NotImplementedException(); }
        public static void SetLayoutMode() { throw new NotImplementedException(); }
        /// <summary>
        /// Set the multi-sample (antialias) format to use.
        /// </summary>
        /// <param name="index"></param>
        public static void SetMultisampleFormat(int index) { throw new NotImplementedException(); } 
        public static void SetScreenResolution(int index) { throw new NotImplementedException(); }
        /// <summary>
        /// Set whether player's cloak is displayed.
        /// </summary>
        /// <param name="flag">Shown</param>
        public static void ShowCloak(bool flag) { throw new NotImplementedException(); }
        /// <summary>
        /// Set whether player's helm is displayed.
        /// </summary>
        /// <param name="flag">Shown</param>
        public static void ShowHelm(bool flag) { throw new NotImplementedException(); } 
        /// <summary>
        /// Returns 1 if detailed threat information should be shown on unit frames.
        /// </summary>
        /// <returns></returns>
        public static bool ShowNumericThreat() { throw new NotImplementedException(); } 
        /// <summary>
        /// Return 1 if player's cloak is displayed, nil otherwise.
        /// </summary>
        /// <returns></returns>
        public static bool ShowingCloak() { throw new NotImplementedException(); }
        /// <summary>
        /// Return 1 if player's helm is displayed, nil otherwise.
        /// </summary>
        /// <returns></returns>
        public static bool ShowingHelm() { throw new NotImplementedException(); } 
        /// <summary>
        /// Uploads a backup of your settings to the server.
        /// </summary>
        public static void UploadSettings() { throw new NotImplementedException(); } 
    }
}
