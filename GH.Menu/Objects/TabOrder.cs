namespace GH.Menu.Objects
{
    using System.Collections.Generic;
    using System.Linq;
    using BlizzardApi.Global;

    public class TabOrder
    {
        private const double OnSameLineTreheshold = 10.0;

        private List<ITabableObject> objects = new List<ITabableObject>();

        public void AddObject(ITabableObject obj)
        {
            this.objects.Add(obj);
        }

        private static double GetSpaceAboveObject(ITabableObject obj)
        {
            return Global.Frames.UIParent.GetHeight() - obj.GetTop();
        }

        private static double GetSpaceBelowObject(ITabableObject obj)
        {
            return obj.GetBottom();
        }
        private static double GetSpaceLeftOfObject(ITabableObject obj)
        {
            return obj.GetLeft();
        }

        private static double GetSpaceRightOfObject(ITabableObject obj)
        {
            return Global.Frames.UIParent.GetWidth() - obj.GetRight();
        }

        public ITabableObject GetHigherObject(ITabableObject obj)
        {
            var top = GetSpaceAboveObject(obj);
            var left = GetSpaceLeftOfObject(obj);
            var higherObjects = this.objects.Where(
                o =>
                    o != obj &&
                    (GetSpaceAboveObject(o) <= top - OnSameLineTreheshold ||
                    (GetSpaceAboveObject(o) <= top + OnSameLineTreheshold && GetSpaceLeftOfObject(o) <= left)));

            return higherObjects.OrderBy(GetSpaceAboveObject).LastOrDefault();
        }

        public ITabableObject GetLowerObject(ITabableObject obj)
        {
            var bottom = GetSpaceBelowObject(obj);
            var right = GetSpaceRightOfObject(obj);
            var lowerObjects = this.objects.Where(
                o =>
                    o != obj &&
                    (GetSpaceBelowObject(o) <= bottom - OnSameLineTreheshold ||
                    (GetSpaceBelowObject(o) <= bottom + OnSameLineTreheshold && GetSpaceRightOfObject(o) <= right)));

            return lowerObjects.FirstOrDefault();
        }
    }
}