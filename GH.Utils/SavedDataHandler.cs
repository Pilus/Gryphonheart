//-----------------------–-----------------------–--------------
// <copyright file="SavedDataHandler.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils
{
    using BlizzardApi.Global;
    using Lua;

    /// <summary>
    /// Handler for data that needs to be saved to and retrieved from a global variable.
    /// </summary>
    public class SavedDataHandler : ISavedDataHandler
    {
        /// <summary>
        /// The name of the global table.
        /// </summary>
        private readonly string tableName;

        /// <summary>
        /// The sub index in the table to act upon.
        /// </summary>
        private readonly string subTableIndex;

        /// <summary>
        /// Initializes a new instance of the <see cref="SavedDataHandler"/> class.
        /// </summary>
        /// <param name="tableName">The name of the global table.</param>
        public SavedDataHandler(string tableName)
        {
            this.tableName = tableName;
            this.subTableIndex = null;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="SavedDataHandler"/> class.
        /// </summary>
        /// <param name="tableName">The name of the global table.</param>
        /// <param name="subTableIndex">The index in the global table for the sub table to act upon.</param>
        public SavedDataHandler(string tableName, string subTableIndex)
        {
            this.tableName = tableName;
            this.subTableIndex = subTableIndex;
        }

        /// <summary>
        /// Retrieve the data at a given index.
        /// </summary>
        /// <param name="index">The index to retrieve from in the data table.</param>
        /// <returns>The data at the given table.</returns>
        public NativeLuaTable GetVar(object index)
        {
            var dataTable = this.GetAll();
            return dataTable[index] as NativeLuaTable;
        }

        /// <summary>
        /// Set data at a given index.
        /// </summary>
        /// <param name="index">The index to set the data to.</param>
        /// <param name="obj">The data to set.</param>
        public void SetVar(object index, NativeLuaTable obj)
        {
            var dataTable = this.GetAll();
            dataTable[index] = obj;
        }

        /// <summary>
        /// Retrieves all data sets from the data table.
        /// </summary>
        /// <returns>A <see cref="NativeLuaTable"/> containing all data sets.</returns>
        public NativeLuaTable GetAll()
        {
            var dataTable = Global.Api.GetGlobal(this.tableName) as NativeLuaTable;
            if (dataTable == null)
            {
                dataTable = new NativeLuaTable();
                Global.Api.SetGlobal(this.tableName, dataTable);
            }

            if (this.subTableIndex == null)
            {
                return dataTable;
            }

            if (dataTable[this.subTableIndex] == null)
            {
                dataTable[this.subTableIndex] = new NativeLuaTable();
            }

            return (NativeLuaTable)dataTable[this.subTableIndex];            
        }
    }
}