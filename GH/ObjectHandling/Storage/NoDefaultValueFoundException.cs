//-----------------------–-----------------------–--------------
// <copyright file="NoDefaultValueFoundException.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.ObjectHandling.Storage
{
    using Lua;

    /// <summary>
    /// Exception for the attempt to get the default value when not found.
    /// </summary>
    public class NoDefaultValueFoundException : BaseException
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="NoDefaultValueFoundException"/> class.
        /// </summary>
        /// <param name="id">Id for the object attempted found.</param>
        public NoDefaultValueFoundException(object id) : base("No default value found for id: {0}", Strings.tostring(id))
        {
        }
    }
}