//-----------------------–-----------------------–--------------
// <copyright file="DefaultObjectAlreadySetException.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.ObjectHandling.Storage
{
    using Lua;

    /// <summary>
    /// Exception thrown when a default object is attempted being set and one with the same id is already present.
    /// </summary>
    public class DefaultObjectAlreadySetException : BaseException
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="DefaultObjectAlreadySetException"/> class.
        /// </summary>
        /// <param name="id">Id for the object attempted set.</param>
        public DefaultObjectAlreadySetException(object id) : base("Default object with id '{0}' have already been set.", Strings.tostring(id))
        {
        }
    }
}