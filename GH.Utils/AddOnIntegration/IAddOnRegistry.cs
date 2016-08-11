//-----------------------–-----------------------–--------------
// <copyright file="IAddOnRegistry.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.AddOnIntegration
{
    /// <summary>
    /// Central point of registry for loaded addOns.
    /// </summary>
    public interface IAddOnRegistry
    {
        /// <summary>
        /// Registers a given addOn in the registry.
        /// </summary>
        /// <param name="addonName">AddOn name reference.</param>
        void RegisterAddOn(AddOnReference addonName);

        /// <summary>
        /// Determines whether an addon with a given name reference is loaded.
        /// </summary>
        /// <param name="addOnName">AddOn name reference.</param>
        /// <returns>Whether the addon is loaded.</returns>
        bool IsAddOnLoaded(AddOnReference addOnName);
    }
}