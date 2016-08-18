//-----------------------–-----------------------–--------------
// <copyright file="IPage.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Menu.Containers.Page
{
    using GH.Menu.Containers.Line;

    /// <summary>
    /// Interface for Page.
    /// </summary>
    public interface IPage : IMenuRegion, IContainer<ILine>
    {
        /// <summary>
        /// Gets the name of the page.
        /// </summary>
        string Name { get; }

        /// <summary>
        /// Shows the page.
        /// </summary>
        void Show();

        /// <summary>
        /// Hides the page.
        /// </summary>
        void Hide();
    }
}
