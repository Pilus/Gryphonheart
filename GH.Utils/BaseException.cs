//-----------------------–-----------------------–--------------
// <copyright file="BaseException.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils
{
    using System;

    /// <summary>
    /// Base exception that allows for automatic formatting of args into a format string.
    /// </summary>
    public class BaseException : Exception
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="BaseException"/> class.
        /// </summary>
        /// <param name="msg">A message as a format string.</param>
        /// <param name="args">The args for the format string.</param>
        public BaseException(string msg, params object[] args) : base(string.Format(msg, args))
        {
        }
    }
}