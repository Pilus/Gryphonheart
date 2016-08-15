//-----------------------–-----------------------–--------------
// <copyright file="IAlignedBlock.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Menu.Containers.AlignedBlock
{
    using GH.Menu.Objects;

    /// <summary>
    /// Interface for aligned block, handling menu objects with same alignment.
    /// </summary>
    public interface IAlignedBlock : IMenuRegion, IContainer<IMenuObject>
    {
    }
}