namespace GH.Menu.Objects
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class TabableEditBox : ITabableObject
    {
        private IEditBox editBox;
        public TabableEditBox(IEditBox editBox)
        {
            this.editBox = editBox;
        }

        public void SetFocus()
        {
            this.editBox.SetFocus();
        }

        public void SetTabAction(Action action)
        {
            this.editBox.SetScript(EditBoxHandler.OnTabPressed, (self) =>
            {
                action();
            });
        }

        public double GetTop()
        {
            return this.editBox.GetTop();
        }

        public double GetBottom()
        {
            return this.editBox.GetBottom();
        }

        public double GetLeft()
        {
            return this.editBox.GetLeft();
        }

        public double GetRight()
        {
            return this.editBox.GetRight();
        }
    }
}