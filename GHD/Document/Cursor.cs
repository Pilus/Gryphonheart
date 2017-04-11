
namespace GHD.Document
{
    using System;
    using GHD.Document.AltElements;
    using GHD.Document.Containers;
    using GHD.Document.Flags;

    public class Cursor : ICursor
    {
        private readonly ITextScoper textScoper;
        private IFlags currentFlags;

        private IElement currentElement;

        public Cursor(ITextScoper textScoper)
        {
            this.textScoper = textScoper;
        }

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
                    this.CurrentElement = HorizontalGroup.GetLastElementInSameGroup(this.CurrentElement);
                    (this.CurrentElement as INavigableElement)?.ResetInsertPosition(true);
                    break;
                case NavigationType.Home:
                    this.CurrentElement = HorizontalGroup.GetFirstElementInSameGroup(this.CurrentElement);
                    (this.CurrentElement as INavigableElement)?.ResetInsertPosition(false);
                    break;
                default:
                    throw new NotImplementedException("Cursor handling of " + navigationType);
            }
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
                this.CurrentElement.InsertElementBefore(new TextElement(this.textScoper, flags, text));
            }

            this.UpdateLayoutOnGroupOfCurrentElement();
        }

        private void UpdateLayoutOnGroupOfCurrentElement()
        { 
            this.CurrentElement.Group.UpdateLayout(this.CurrentElement);

            this.SeekUpdatedCurrentElement();
        }

        private void SeekUpdatedCurrentElement()
        {
            if (this.CurrentElement.HasCursor())
            {
                return;
            }

            var backwards = this.CurrentElement.Prev;
            var forwards = this.CurrentElement.Next;

            while (backwards != null || forwards != null)
            {
                if (backwards != null)
                {
                    if (backwards.HasCursor())
                    {
                        this.currentElement = backwards;
                        return;
                    }
                    backwards = backwards.Prev;
                }

                if (forwards != null)
                {
                    if (forwards.HasCursor())
                    {
                        this.currentElement = forwards;
                        return;
                    }
                    forwards = forwards.Next;
                }
            }
        }
    }
}
