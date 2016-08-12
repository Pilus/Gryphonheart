﻿//-----------------------–-----------------------–--------------
// <copyright file="NonSingletonModule.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------

namespace GH.Utils.Modules
{
    using GH.Utils.Entities;

    /// <summary>
    /// An abstract module flagged as not a singleton.
    /// </summary>
    public abstract class NonSingletonModule : IModule
    {
        /// <summary>
        /// Gets a value indicating whether the module is a singleton module or not.
        /// </summary>
        public bool IsSingleton => false;

        /// <summary>
        /// Gets a idObject that containing the default settings of the module.
        /// </summary>
        /// <returns>The settings.</returns>
        public abstract IIdObject<string> GetDefaultSettings();

        /// <summary>
        /// Applies a settings object to the module.
        /// </summary>
        /// <param name="settings">The settings object as an IdObject with string as id.</param>
        public abstract void ApplySettings(IIdObject<string> settings);
    }
}