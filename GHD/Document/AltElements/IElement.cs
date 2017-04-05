namespace GHD.Document.AltElements
{
    using GHD.Document.Containers;
    using GHD.Document.Flags;

    public interface IElement
    {
        void Insert(IFlags newFlags, string newText);

        void ResetInsertPosition(bool inEnd = false);

        /// <summary>
        /// Perform cursor navigation event on the element.
        /// </summary>
        /// <param name="navigationType"></param>
        /// <returns>A flag indicating if the navigation was successful.</returns>
        bool Navigate(NavigationType navigationType);

        IElement Prev { get; set; }

        IElement Next { get; set; }

        HorizontalGroup Group { get; set; }

        IFlags Flags { get; }
    }
}