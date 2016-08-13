//-----------------------–-----------------------–--------------
// <copyright file="DefaultEntityCanNotBeSetAfterLoadException.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.Entities.Storage
{
    using Lua;

    /// <summary>
    /// Exception thrown if a default entity is attempted set after the data is loaded.
    /// </summary>
    public class DefaultEntityCanNotBeSetAfterLoadException : BaseException
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="DefaultEntityCanNotBeSetAfterLoadException"/> class.
        /// </summary>
        /// <param name="id">Id for the entity attempted set.</param>
        public DefaultEntityCanNotBeSetAfterLoadException(object id) : base("Default entity with id '{0}' attempted to be set after data have been loaded.", Strings.tostring(id))
        {
        }
    }
}