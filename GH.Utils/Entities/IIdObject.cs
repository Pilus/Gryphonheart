//-----------------------–-----------------------–--------------
// <copyright file="IIdObject.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.Entities
{
    /// <summary>
    /// An entity with an id.
    /// </summary>
    /// <typeparam name="T">The id type.</typeparam>
    public interface IIdObject<T>
    {
        /// <summary>
        /// Gets the id of the entity.
        /// </summary>
        T Id { get; }
    }
}