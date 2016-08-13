//-----------------------–-----------------------–--------------
// <copyright file="DefaultEntityAlreadySetException.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.Entities.Storage
{
    using Lua;

    /// <summary>
    /// Exception thrown when a default entity is attempted being set and one with the same id is already present.
    /// </summary>
    public class DefaultEntityAlreadySetException : BaseException
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="DefaultEntityAlreadySetException"/> class.
        /// </summary>
        /// <param name="id">Id for the entity attempted set.</param>
        public DefaultEntityAlreadySetException(object id) : base("Default entity with id '{0}' have already been set.", Strings.tostring(id))
        {
        }
    }
}