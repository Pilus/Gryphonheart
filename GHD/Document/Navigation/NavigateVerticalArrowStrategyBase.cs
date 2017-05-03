namespace GHD.Document.Navigation
{
    using GHD.Document.Elements;
    using GHD.Document.Groups;

    public abstract class NavigateVerticalArrowStrategyBase : NavigateStrategyBase
    {
        protected NavigateVerticalArrowStrategyBase(NavigationType navigationType) : base(navigationType)
        {
        }

        public override void Navigate(ICursor cursor)
        {
            double offset = (cursor.CurrentElement as INavigableElement)?.GetInsertXOffset() ?? 0;
            var element = cursor.CurrentElement.Prev;
            while (element.Group == cursor.CurrentElement.Group)
            {
                offset += element.GetWidth();
                element = element.Prev;
            }

            var elementInOtherGroup = this.GetElementInOtherGroup(cursor);
            var otherGroup = elementInOtherGroup.Group;
            var firstInOtherGroup = elementInOtherGroup.Group.FirstElement;

            double prevOffset = 0;
            element = firstInOtherGroup;

            while (element.Group == otherGroup && prevOffset + element.GetWidth() <= offset)
            {
                prevOffset += element.GetWidth();
                element = element.Next;
            }

            if (element.Group != otherGroup)
            {
                cursor.CurrentElement = element.Prev;
                (cursor.CurrentElement as INavigableElement)?.ResetInsertPosition(true);
            }
            else
            {
                cursor.CurrentElement = element;
                (cursor.CurrentElement as INavigableElement)?.SetInsertPosition(offset - prevOffset, 0);
            }
        }

        protected abstract IElement GetElementInOtherGroup(ICursor cursor);
    }
}