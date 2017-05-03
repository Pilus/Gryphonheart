
namespace GHD.Document
{
    using System;
    using GHD.Document.Elements;
    using GHD.Document.Flags;
    using GHD.Document.Groups;
    using GHD.Document.Navigation;

    public class Cursor : ICursor
    {
        private readonly ITextScoper textScoper;
        private IFlags currentFlags;
        private IElement currentElement;

        public Cursor(ITextScoper textScoper)
        {
            this.textScoper = textScoper;
        }

        public IElement CurrentElement
        {
            get { return this.currentElement; }
            set
            {
                if (this.currentElement == value) return;

                this.currentElement?.LooseCursor();
                this.currentElement = value;
                this.currentElement?.GainCursor(this);
            }
        }

        public IFlags CurrentFlags
        {
            get { return this.currentFlags ?? this.CurrentElement.Flags; }
            set { this.currentFlags = value; }
        }

        public void Navigate(NavigationType navigationType)
        {
            if (this.CurrentElement == null)
            {
                throw new Exception("Can not navigate without cursor focus.");
            }

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
                case NavigationType.Up:
                    double offset = (this.CurrentElement as INavigableElement) ?.GetInsertXOffset() ?? 0;
                    var element = this.CurrentElement.Prev;
                    while (element.Group == this.CurrentElement.Group)
                    {
                        offset += element.GetWidth();
                        element = element.Prev;
                    }

                    var prevGroup = element.Group;
                    var firstInPrevGroup = HorizontalGroup.GetFirstElementInSameGroup(element);

                    double prevOffset = 0;
                    element = firstInPrevGroup;

                    while (element.Group == prevGroup && prevOffset + element.GetWidth() <= offset)
                    {
                        prevOffset += element.GetWidth();
                        element = element.Next;
                    }

                    if (element.Group != prevGroup)
                    {
                        this.CurrentElement = element.Prev;
                        (this.CurrentElement as INavigableElement)?.ResetInsertPosition(true);
                    }
                    else
                    {
                        this.CurrentElement = element;
                        (this.CurrentElement as INavigableElement)?.SetInsertPosition(offset - prevOffset, 0);
                    }

                    break;
                default:
                    throw new NotImplementedException("Cursor handling of " + navigationType);
            }

            if (this.CurrentElement == null)
            {
                throw new Exception("Focus lost unexpectedly.");
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
                        this.CurrentElement = backwards;
                        return;
                    }
                    backwards = backwards.Prev;
                }

                if (forwards != null)
                {
                    if (forwards.HasCursor())
                    {
                        this.CurrentElement = forwards;
                        return;
                    }
                    forwards = forwards.Next;
                }
            }
        }
    }
}
