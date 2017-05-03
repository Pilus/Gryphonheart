
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
        private readonly Navigator navigator;

        public Cursor(ITextScoper textScoper, Navigator navigator)
        {
            this.textScoper = textScoper;
            this.navigator = navigator;
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

            this.navigator.Navigate(this, navigationType);

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
