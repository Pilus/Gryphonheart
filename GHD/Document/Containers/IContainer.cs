
namespace GHD.Document.Containers
{
    using System;
    using BlizzardApi.WidgetInterfaces;
    using Buffer;
    using Elements;
    using Flags;

    /// <summary>
    /// Interface for containers.
    /// </summary>
    public interface IContainer : IElement
    {
        /// <summary>
        /// Gets the <see cref="IElement"/> currently at the cursor position.
        /// </summary>
        /// <returns>The element.</returns>
        IElement GetCurrentElement();
    }
}
