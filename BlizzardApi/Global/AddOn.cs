namespace BlizzardApi.Global
{
    public partial interface IApi
    {
        /// <summary>
        /// Disable the specified AddOn for subsequent sessions.
        /// </summary>
        /// <param name="index">Index of the AddOn.</param>
        void DisableAddOn(int index);
        /// <summary>
        /// Disable the specified AddOn for subsequent sessions.
        /// </summary>
        /// <param name="addOnName">Name of the AddOn.</param>
        void DisableAddOn(string addOnName);
        /// <summary>
        /// Disable all AddOns for subsequent sessions.
        /// </summary>
        void DisableAllAddOns();
        /// <summary>
        /// Enable the specified AddOn for subsequent sessions.
        /// </summary>
        /// <param name="index">Index of the AddOn.</param>
        void EnableAddOn(int index);
        /// <summary>
        /// Enable the specified AddOn for subsequent sessions.
        /// </summary>
        /// <param name="addOnName">Name of the AddOn.</param>
        void EnableAddOn(string addOnName);
        /// <summary>
        /// Enable all AddOns for subsequent sessions.
        /// </summary>
        void EnableAllAddOns();
        /// <summary>
        /// Retrieve metadata from addon's TOC file.
        /// </summary>
        /// <param name="index">Index of the AddOn.</param>
        /// <param name="variable">The name of the variable to retreive.</param>
        string GetAddOnMetadata(int index, string variable);
        /// <summary>
        /// Retrieve metadata from addon's TOC file.
        /// </summary>
        /// <param name="addOnName">Name of the AddOn.</param>
        /// <param name="variable">The name of the variable to retreive.</param>
        string GetAddOnMetadata(string addOnName, string variable);
        /*
       
        GetAddOnDependencies(index or "AddOnName") - Get dependency list for an AddOn. 

        GetAddOnInfo(index or "AddOnName") - Get information about an AddOn. 

        GetNumAddOns() - Get the number of user supplied AddOns. 

        IsAddOnLoaded(index or "AddOnName") - Returns true if the specified AddOn is loaded. 

        IsAddOnLoadOnDemand(index or "AddOnName") - Test whether an AddOn is load-on-demand. 

        LoadAddOn(index or "AddOnName") - Request loading of a Load-On-Demand AddOn. 

        ResetDisabledAddOns()  
       */
    }
}