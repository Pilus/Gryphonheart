namespace GH.Menu.Objects
{
    using System;

    public interface ITabableObject
    {
        void SetFocus();
        void SetTabAction(Action action);
        double GetTop();
        double GetBottom();
        double GetLeft();
        double GetRight();
    }
}