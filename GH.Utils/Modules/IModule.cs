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
    }
}