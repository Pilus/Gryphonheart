
namespace BlizzardApi.Global
{
    using CsLuaFramework.Wrapping;
    using MiscEnums;

    public partial interface IApi
    {
        /// <summary>
        /// changes the entity for which COMBAT_TEXT_UPDATE events fire.
        /// </summary>
        /// <param name="unit">UnitId of the entity you want receive notifications for.</param>
        string CombatTextSetActiveUnit(UnitId unit);
        /// <summary>
        /// Download a backup of your settings from the server.
        /// </summary>
        //void DownloadSettings(); // Seems to be missing 
        /// <summary>
        /// Returns the current value of a console variable.
        /// </summary>
        /// <param name="cVar">Name of the console variable</param>
        /// <returns></returns>
        object GetCVar(string cVar);
        /// <summary>
        /// Returns the default value of a console variable.
        /// </summary>
        /// <param name="cVar"></param>
        /// <returns></returns>
        object GetCVarDefault(string cVar); 
        /// <summary>
        /// Returns the value of the cvar as 1 or nil instead of requiring you to compare the cvar value with "0" or "1"
        /// </summary>
        /// <param name="cVar"></param>
        /// <returns></returns>
        bool GetCVarBool(string cVar); 
        /// <summary>
        /// returns name, defaultValue, serverStoredAccountWide, serverStoredPerCharacter
        /// </summary>
        /// <param name="cVar"></param>
        /// <returns></returns>
        IMultipleValues<string, object, bool, bool> GetCVarInfo(string cVar); 
        /// <summary>
        /// Get the current in-use multi-sample (antialias) format.
        /// </summary>
        /// <returns></returns>
        int GetCurrentMultisampleFormat(); 
        /// <summary>
        /// Get the index of the current screen resolution.
        /// </summary>
        /// <returns>This value will be the index of one of the values yielded by GetScreenResolutions()</returns>
        int GetCurrentResolution() ; 
        double GetGamma();
        /// <summary>
        /// Get the available multi-sample (antialias) formats.
        /// </summary>
        /// <returns></returns>
        int GetMultisampleFormats(); 
        /// <summary>
        /// Gets the refresh rate of a resolution.
        /// </summary>
        /// <param name="i">Index of the resolution you want to get the refresh rates for. Must be an index returned by GetScreenResolutions(). Passing nil defaults this argument to 1, the lowest resolution available.</param>
        /// <returns></returns>
        int GetRefreshRates(int i);
        /// <summary>
        /// Gets the refresh rate of the first resolution.
        /// </summary>
        /// <returns></returns>
        int GetRefreshRates();
        IMultipleValues<string,string,string> GetScreenResolutions();
        object GetVideoCaps();
        /// <summary>
        /// returns whether threat warnings should currently be displayed.
        /// </summary>
        /// <returns></returns>
        bool IsThreatWarningEnabled(); 
        /// <summary>
        /// Registers a variable for use with the #GetCVar and #SetCVar functions.
        /// </summary>
        /// <param name="cVar"></param>
        void RegisterCVar(string cVar); 
        /// <summary>
        /// Registers a variable for use with the #GetCVar and #SetCVar functions.
        /// </summary>
        /// <param name="cVar"></param>
        /// <param name="value"></param>
        void RegisterCVar(string cVar, object value); 
        void ResetPerformanceValues();
        void ResetTutorials();
        /// <summary>
        /// Set the value of a variable in config.wtf
        /// </summary>
        /// <param name="cVar"></param>
        /// <param name="value"></param>
        void SetCVar(string cVar, object value); 
        /// <summary>
        /// Set the value of a variable in config.wtf
        /// </summary>
        /// <param name="cVar"></param>
        /// <param name="value"></param>
        /// <param name="scriptCVar"></param>
        void SetCVar(string cVar, object value, string scriptCVar);
        /// <summary>
        /// Sets the decimal separator to a comma instead of a dot
        /// </summary>
        /// <param name="flag">enable</param>
        void SetEuropeanNumbers(bool flag); 
        void SetGamma(double value);
        void SetLayoutMode();
        /// <summary>
        /// Set the multi-sample (antialias) format to use.
        /// </summary>
        /// <param name="index"></param>
        void SetMultisampleFormat(int index); 
        void SetScreenResolution(int index);
        /// <summary>
        /// Set whether player's cloak is displayed.
        /// </summary>
        /// <param name="flag">Shown</param>
        void ShowCloak(bool flag);
        /// <summary>
        /// Set whether player's helm is displayed.
        /// </summary>
        /// <param name="flag">Shown</param>
        void ShowHelm(bool flag); 
        /// <summary>
        /// Returns 1 if detailed threat information should be shown on unit frames.
        /// </summary>
        /// <returns></returns>
        bool ShowNumericThreat(); 
        /// <summary>
        /// Return 1 if player's cloak is displayed, nil otherwise.
        /// </summary>
        /// <returns></returns>
        bool ShowingCloak();
        /// <summary>
        /// Return 1 if player's helm is displayed, nil otherwise.
        /// </summary>
        /// <returns></returns>
        bool ShowingHelm(); 
        /// <summary>
        /// Uploads a backup of your settings to the server.
        /// </summary>
        void UploadSettings(); 
    }
}
