//-----------------------–-----------------------–--------------
// <copyright file="ISavedDataHandler.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils
{
    using Lua;

    /// <summary>
    /// Handler for data that needs to be saved to and retrieved from a global variable.
    /// </summary>
    public interface ISavedDataHandler
    {
        /// <summary>
        /// Retrieve the data at a given index.
        /// </summary>
        /// <param name="index">The index to retrieve from in the data table.</param>
        /// <returns>The data at the given table.</returns>
        NativeLuaTable GetVar(object index);

        /// <summary>
        /// Set data at a given index.
        /// </summary>
        /// <param name="index">The index to set the data to.</param>
        /// <param name="obj">The data to set.</param>
        void SetVar(object index, NativeLuaTable obj);

        /// <summary>
        /// Retrieves all data sets from the data table.
        /// </summary>
        /// <returns>A <see cref="NativeLuaTable"/> containing all data sets.</returns>
        NativeLuaTable GetAll();
    }
}