//-----------------------–-----------------------–--------------
// <copyright file="DataNotLoadedException.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.Entities.Storage
{
    /// <summary>
    /// Exception for attempt to access data from a dataset that have not yet been loaded.
    /// </summary>
    public class DataNotLoadedException : BaseException
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="DataNotLoadedException"/> class.
        /// </summary>
        public DataNotLoadedException() : base("It is not possible to interact with objects before the saved data is loaded.")
        {
        }
    }
}