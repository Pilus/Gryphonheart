//-----------------------–-----------------------–--------------
// <copyright file="ILine.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Menu.Containers.Line
{
    using GH.Menu.Containers.AlignedBlock;
    using GH.Menu.Objects;

    /// <summary>
    /// Interface for lines.
    /// </summary>
    public interface ILine : IMenuRegion, IContainer<IAlignedBlock>
    {
        void AddObjectByProfile(IObjectProfile profile, IMenuHandler handler);
    }
}
