//-----------------------–-----------------------–--------------
// <copyright file="ModuleFactory.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------

namespace GH.Utils.Modules
{
    using System;
    using System.Collections.Generic;
    using GH.Utils.Entities;

    /// <summary>
    /// Factory for modules, which handles loading of settings, as well as allows for singleton management.
    /// </summary>
    public class ModuleFactory : IModuleFactory
    {
        /// <summary>
        /// Get a module of the desired type.
        /// </summary>
        /// <typeparam name="T">The type of the module.</typeparam>
        /// <returns>The module.</returns>
        public T GetModule<T>() where T : IModule, new()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Loads a given set of settings to apply to all existing modules and all future modules.
        /// </summary>
        /// <param name="settings">The settings to apply.</param>
        public void LoadSettings(IEnumerable<IIdObject<string>> settings)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Gets the default settings of all already loaded modules.
        /// </summary>
        /// <returns>The settings to load.</returns>
        public IEnumerable<IIdObject<string>> GetDefaultSettingsOfLoadedModules()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Registers a callback that is triggered when a module is being created.
        /// </summary>
        /// <param name="callback">The callback triggered with the module and a flag indicating whether it is the first module of its type.</param>
        public void RegisterForModuleLoadEvents(Action<IModule, bool> callback)
        {
            throw new NotImplementedException();
        }
    }
}