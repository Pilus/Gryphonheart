
namespace GHD.Document
{
    using System;
    using GHD.Document.Elements;
    using GHD.Document.Flags;
    using GHD.Document.Groups;
    using GHD.Document.Groups.LayoutStrategies;
    using GHD.Document.Navigation;

    public class Cursor : ICursor
    {
        private readonly ITextScoper textScoper;
        private IFlags currentFlags;
        private readonly Navigator navigator;

        private readonly LayoutUpdater layoutUpdater;

        public Cursor(ITextScoper textScoper, Navigator navigator, LayoutUpdater layoutUpdater)
        {
            this.textScoper = textScoper;
            this.navigator = navigator;
            this.layoutUpdater = layoutUpdater;
        }

        public IElement CurrentElement { get; set; }

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
            this.layoutUpdater.UpdateLayout(this.CurrentElement.Group);
        }
    }
}
