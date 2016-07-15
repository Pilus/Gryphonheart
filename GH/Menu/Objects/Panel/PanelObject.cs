
namespace GH.Menu.Objects.Panel
{
    using BlizzardApi.WidgetInterfaces;
    using Page;
    using Containers.Line;
    using CsLuaFramework.Wrapping;

    public class PanelObject : BaseObject, IContainer<ILine>, IMenuObject
    {
        public static string Type = "Panel";

        private const double BorderSize = 0;
        private const double ExtraTopSize = 0;

        private string name;

        private IPage innerPage;

        public PanelObject(IWrapper wrapper) : base(Type, wrapper)
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
            base.Prepare(profile, handler);
            var panelProfile = (PanelProfile)profile;
            var innerPageProfile = new PageProfile();
            panelProfile.ForEach(innerPageProfile.Add);
            this.innerPage = (IPage)handler.CreateRegion(innerPageProfile);
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

        public IMenuObject GetFrameById(string id)
        {
            return this.innerPage.GetFrameById(id);
        }
    }
}
