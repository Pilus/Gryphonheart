//-----------------------–-----------------------–--------------
// <copyright file="IModuleFactory.cs">
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
    public interface IModuleFactory
    {
        /// <summary>
        /// Get a module of the desired type.
        /// </summary>
        /// <typeparam name="T">The type of the module.</typeparam>
        /// <returns>The module.</returns>
        T GetModule<T>() where T : IModule, new();

        /// <summary>
        /// Loads a given set of settings to apply to all existing modules and all future modules.
        /// </summary>
        /// <param name="settings">The settings to apply.</param>
        void LoadSettings(IEnumerable<IIdObject<string>> settings);

        /// <summary>
        /// Gets the default settings of all already loaded modules.
        /// </summary>
        /// <returns>The settings to load.</returns>
        IEnumerable<IIdObject<string>> GetDefaultSettingsOfLoadedModules();

        /// <summary>
        /// Registers a callback that is triggered when a module is being created.
        /// </summary>
        /// <param name="callback">The callback triggered.</param>
        void RegisterForModuleLoadEvents(Action<IModule> callback);
    }
}