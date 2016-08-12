//-----------------------–-----------------------–--------------
// <copyright file="IModule.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------

namespace GH.Utils.Modules
{
    using GH.Utils.Entities;

    /// <summary>
    /// Interface for dynamic modules with settings.
    /// </summary>
    public interface IModule
    {
        /// <summary>
        /// Gets a value indicating whether the module is a singleton module or not.
        /// </summary>
        bool IsSingleton { get; }

        /// <summary>
        /// Gets a idObject that containing the default settings of the module.
        /// </summary>
        /// <returns>The settings.</returns>
        IIdObject<string> GetDefaultSettings();

        /// <summary>
        /// Applies a settings object to the module.
        /// </summary>
        /// <param name="settings">The settings object as an IdObject with string as id.</param>
        void ApplySettings(IIdObject<string> settings);
    }
}