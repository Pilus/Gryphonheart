namespace GHD.Document.Elements
{
    using GHD.Document.Flags;
    using GHD.Document.Navigation;

    public interface INavigableElement : IElement
    {
        /// <summary>
        /// Inserts a text in the element.
        /// </summary>
        /// <param name="newFlags"></param>
        /// <param name="newText"></param>
        void Insert(IFlags newFlags, string newText);

        void ResetInsertPosition(bool inEnd = false);

        void SetInsertPosition(double xOffset, double yOffset);

        double GetInsertXOffset();

        /// <summary>
        /// Perform cursor navigation event on the element.
        /// </summary>
        /// <param name="navigationType"></param>
        /// <returns>A flag indicating if the navigation was successful.</returns>
        bool Navigate(NavigationType navigationType);
    }
}