namespace WoWSimulator.UISimulation.UiObjects
{
    using System.Collections.Generic;
    using BlizzardApi.WidgetInterfaces;
    using Moq;
    using XMLHandler;

    public class UIObject : IUIObject
    {
        private double alpha = 1.0;
        private readonly Dictionary<object, object> innerDictionary = new Dictionary<object, object>();
        private string name;
        private readonly string objectType;

        public UIObject(UiInitUtil util, string objectType, LayoutFrameType layout, IRegion parent)
        {
            this.objectType = objectType;
            if (!string.IsNullOrEmpty(layout.inherits))
            {
                this.ApplyLayout(util.GetTemplate(layout.inherits) as LayoutFrameType, parent);
            }
            this.ApplyLayout(layout, parent);
        }

        private void ApplyLayout(LayoutFrameType layout, IRegion parent)
        {
            this.SetName(layout.name, parent);
            if (layout is FrameType)
            {
                this.alpha = ((FrameType)layout).alpha;
            }
        }

        private void SetName(string name, IRegion parent)
        {
            if (name != null)
            {
                this.name = parent != null ? name.Replace("$parent", parent.GetName()) : name;
            }
        }

        public double GetAlpha()
        {
            return this.alpha;
        }

        public string GetName()
        {
            return this.name;
        }

        public string GetObjectType()
        {
            return this.objectType;
        }

        public bool IsForbidden()
        {
            return false;
        }

        public bool IsObjectType(string type)
        {
            return this.objectType == type;
        }

        public void SetAlpha(double alpha)
        {
            this.alpha = alpha;
        }

        public object this[object key]
        {
            get
            {
                return this.innerDictionary.ContainsKey(key) ? this.innerDictionary[key] : null;
            }
            set { this.innerDictionary[key] = value; }
        }
    }
}