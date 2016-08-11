//-----------------------–-----------------------–--------------
// <copyright file="AddOnAlreadyRegisteredException.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.AddOnIntegration
{
    /// <summary>
    /// Exception thrown in the addOn registry.
    /// </summary>
    public class AddOnAlreadyRegisteredException : BaseException
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AddOnAlreadyRegisteredException"/> class.
        /// </summary>
        public AddOnAlreadyRegisteredException() : base("AddOn already registered.")
        {
        }
    }
}