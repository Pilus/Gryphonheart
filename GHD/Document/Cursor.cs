
namespace GHD.Document
{
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
            bool success;
            switch (navigationType)
            {
                case NavigationType.Left:
                    success = this.CurrentElement.Navigate(navigationType);
                    while (!success && this.CurrentElement.Prev != null)
                    {
                        this.CurrentElement = this.CurrentElement.Prev;
                        this.CurrentElement.ResetInsertPosition(true);
                        success = this.CurrentElement.Navigate(navigationType);
                    }
                    break;
                case NavigationType.Right:
                    success = this.CurrentElement.Navigate(navigationType);
                    while (!success && this.CurrentElement.Next != null)
                    {
                        this.CurrentElement = this.CurrentElement.Next;
                        this.CurrentElement.ResetInsertPosition(false);
                        success = this.CurrentElement.Navigate(navigationType);
                    }
                    break;
                default:
                    break;
            }
        }
    }
}
