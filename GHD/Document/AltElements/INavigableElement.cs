namespace GHD.Document.AltElements
{
    using GHD.Document.Containers;
    using GHD.Document.Flags;

    public interface INavigableElement : IElement
    {
        /// <summary>
        /// Inserts a text in the element.
        /// </summary>
        /// <param name="newFlags"></param>
        /// <param name="newText"></param>
        /// <returns>List of groups that is need of update.</returns>
        DistinctList<IGroup> Insert(IFlags newFlags, string newText);

        void ResetInsertPosition(bool inEnd = false);

        /// <summary>
        /// Perform cursor navigation event on the element.
        /// </summary>
        /// <param name="navigationType"></param>
        /// <returns>A flag indicating if the navigation was successful.</returns>
        bool Navigate(NavigationType navigationType);
    }
}