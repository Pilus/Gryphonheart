
namespace GHD.Document
{
    using System;
    using GHD.Document.AltElements;
    using GHD.Document.Containers;
    using GHD.Document.Flags;

    public class Cursor : ICursor
    {
        private IFlags currentFlags;

        public IElement CurrentElement { get; set; }

        public IFlags CurrentFlags
        {
            get { return this.currentFlags ?? this.CurrentElement.Flags; }
            set { this.currentFlags = value; }
        }

        public void Navigate(NavigationType navigationType)
        {
            switch (navigationType)
            {
                case NavigationType.Left:
                    bool internalNavigationSuccessful = (this.CurrentElement as INavigableElement)?.Navigate(navigationType) ?? false;

                    if (!internalNavigationSuccessful && this.CurrentElement.Prev != null)
                    {
                        this.CurrentElement = this.CurrentElement.Prev;
                        (this.CurrentElement as INavigableElement)?.ResetInsertPosition(false);
                    }
                    break;
                case NavigationType.End:
                    this.CurrentElement = GetLastElementInSameGroup(this.CurrentElement);
                    (this.CurrentElement as INavigableElement)?.ResetInsertPosition(true);
                    break;
                case NavigationType.Home:
                    this.CurrentElement = GetFirstElementInSameGroup(this.CurrentElement);
                    (this.CurrentElement as INavigableElement)?.ResetInsertPosition(false);
                    break;
                default:
                    throw new NotImplementedException("Cursor handling of " + navigationType);
            }
        }

        private static IElement GetLastElementInSameGroup(IElement element)
        {
            var horizontalGroup = element.Group;

            while (element.Group == horizontalGroup && element.Next != null)
            {
                element = element.Next;
            }

            return element;
        }

        private static IElement GetFirstElementInSameGroup(IElement element)
        {
            var horizontalGroup = element.Group;

            while (element.Group == horizontalGroup && element.Prev != null)
            {
                element = element.Prev;
            }

            return element;
        }

        public void Insert(IFlags flags, string text)
        {
            var currentElementAsNavigable = this.CurrentElement as INavigableElement;
            if (currentElementAsNavigable != null)
            {
                currentElementAsNavigable.Insert(flags, text);
            }
            else
            {
                var newTextElement = new TextElement(flags, text)
                {
                    Prev = this.CurrentElement.Prev,
                    Next = this.CurrentElement,
                    Group = this.CurrentElement.Group,
                };

                if (this.CurrentElement.Prev != null)
                {
                    this.CurrentElement.Prev.Next = newTextElement;
                }
                
                this.CurrentElement.Prev = newTextElement;
                this.CurrentElement = newTextElement;
            }
        }

        private void UpdateLayoutOnGroupOfCurrentElement()
        {
            var first = GetFirstElementInSameGroup(this.CurrentElement);
            var last = GetLastElementInSameGroup(this.CurrentElement);

        }
    }
}
