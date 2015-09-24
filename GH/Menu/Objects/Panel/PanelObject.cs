
namespace GH.Menu.Objects.Panel
{
    using System;
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using Line;
    using Lua;
    using Page;
    using BlizzardApi.Global;
    using Containers;
    using Containers.Line;
    using Theme;
    using Toolbar;

    public class PanelObject : BaseObject, IContainer<ILine>, IMenuObject
    {
        public static string Type = "Panel";

        private const double BorderSize = 0;
        private const double ExtraTopSize = 0;

        private string name;

        private IPage innerPage;

        public PanelObject() : base(Type)
        {
            
        }

        

        public override void SetPosition(IFrame parent, double xOff, double yOff, double width, double height)
        {
            base.SetPosition(parent, xOff, yOff, width, height);
            this.innerPage.SetPosition(
                    this.Frame,
                    BorderSize,
                    BorderSize + ExtraTopSize,
                    width - (BorderSize * 2),
                    height - (BorderSize * 2 + ExtraTopSize));
            this.Frame.SetFrameLevel(parent.GetFrameLevel() + 1);
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            this.innerPage = (IPage)handler.CreateRegion(new PageProfile());
            base.Prepare(profile, handler);
            var panelProfile = (PanelProfile) profile;
            this.name = panelProfile.name;
        }


        public override double? GetPreferredHeight()
        {
            if (this.innerPage == null)
            {
                return 0;
            }

            var height = this.innerPage.GetPreferredHeight();
            if (height != null)
            {
                return height + BorderSize * 2 + ExtraTopSize;
            }
            return null;
        }

        public override double? GetPreferredWidth()
        {
            if (this.innerPage == null)
            {
                return 0;
            }

            var width = this.innerPage.GetPreferredWidth();
            if (width != null)
            {
                return width + BorderSize * 2;
            }
            return null;
        }

        public void SetValue(string id, object value)
        {
            this.innerPage.SetValue(id, value);
        }

        public object GetValue(string id)
        {
            return this.innerPage.GetValue(id);
        }

        public void AddElement(ILine element)
        {
            this.innerPage.AddElement(element);
        }

        public void AddElement(ILine element, int index)
        {
            this.innerPage.AddElement(element, index);
        }

        public void RemoveElement(int index)
        {
            this.innerPage.RemoveElement(index);
        }

        public int GetNumElements()
        {
            return this.innerPage.GetNumElements();
        }

        public ILine GetElement(int index)
        {
            return this.innerPage.GetElement(index);
        }
    }
}
