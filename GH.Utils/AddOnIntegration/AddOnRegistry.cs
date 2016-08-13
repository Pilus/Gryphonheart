//-----------------------–-----------------------–--------------
// <copyright file="AddOnRegistry.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.AddOnIntegration
{
    using System.Collections.Generic;

    using GH.Utils.Modules;

    /// <summary>
    /// Central point of registry for loaded addOns.
    /// </summary>
    public class AddOnRegistry : SingletonModule, IAddOnRegistry
    {
        /// <summary>
        /// List of loaded addOns.
        /// </summary>
        private readonly List<AddOnReference> addOns = new List<AddOnReference>();

        /// <summary>
        /// Registers a given addOn in the registry.
        /// </summary>
        /// <param name="addonName">AddOn name reference.</param>
        public void RegisterAddOn(AddOnReference addonName)
        {
            if (this.addOns.Contains(addonName))
            {
                throw new AddOnAlreadyRegisteredException();
            }

            this.addOns.Add(addonName);
        }

        /// <summary>
        /// Determines whether an addon with a given name reference is loaded.
        /// </summary>
        /// <param name="addOnName">AddOn name reference.</param>
        /// <returns>Whether the addon is loaded.</returns>
        public bool IsAddOnLoaded(AddOnReference addOnName)
        {
            return addOnName.Equals(AddOnReference.None) || this.addOns.Contains(addOnName);
        }
    }
}