//-----------------------–-----------------------–--------------
// <copyright file="DefaultObjectCanNotBeSetAfterLoadException.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.Entities.Storage
{
    using Lua;

    /// <summary>
    /// Exception thrown if a default object is attempted set after the data is loaded.
    /// </summary>
    public class DefaultObjectCanNotBeSetAfterLoadException : BaseException
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="DefaultObjectCanNotBeSetAfterLoadException"/> class.
        /// </summary>
        /// <param name="id">Id for the object attempted set.</param>
        public DefaultObjectCanNotBeSetAfterLoadException(object id) : base("Default object with id '{0}' attempted to be set after data have been loaded.", Strings.tostring(id))
        {
        }
    }
}