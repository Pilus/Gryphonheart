﻿namespace GHD.Document.Navigation
{
    using GHD.Document.Elements;
    using GHD.Document.Groups;

    public class NavigateEndStrategy : NavigateStrategyBase
    {
        public NavigateEndStrategy() : base(NavigationType.End)
        {
        }

        public override void Navigate(ICursor cursor)
        {
            cursor.CurrentElement = cursor.CurrentElement.Group.LastElement;
            (cursor.CurrentElement as INavigableElement)?.ResetInsertPosition(true);
        }
    }
}