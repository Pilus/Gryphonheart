//-----------------------–-----------------------–--------------
// <copyright file="AddOnReference.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.AddOnIntegration
{
    /// <summary>
    /// AddOn name references.
    /// </summary>
    public enum AddOnReference
    {
        /// <summary>
        /// Flag for no particular addOn affiliation.
        /// </summary>
        None,
        
        /// <summary>
        /// Gryphonheart core.
        /// </summary>
        GH,

        /// <summary>
        /// Gryphonheart Items.
        /// </summary>
        GHI,

        /// <summary>
        /// Gryphonheart Groups.
        /// </summary>
        GHG,

        /// <summary>
        /// Gryphonheart Flags.
        /// </summary>
        GHF,

        /// <summary>
        /// Gryphonheart Documents.
        /// </summary>
        GHD,

        /// <summary>
        /// Gryphonheart Crime.
        /// </summary>
        GHC,
    }
}