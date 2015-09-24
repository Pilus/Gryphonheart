namespace GH.Menu.Objects.Page
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;
    using Debug;
    using GH.Menu.Containers;
    using GH.Menu.Containers.Line;
    using Line;
    using Lua;
    using Theme;

    public class Page : BaseContainer<ILine>, IPage
    {
        private double lineSpacing;

        public Page() : base("Page")
        {
            
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            var pageProfile = (PageProfile)profile;
            this.Name = pageProfile.name;
            this.lineSpacing = handler.Layout.lineSpacing;
        }

        public void Show()
        {
            this.Frame.Show();
        }


        public void Hide()
        {
            this.Frame.Hide();
        }

        
        public double? GetPreferredWidth()
        {
            var gotLineWithNoLimit = this.content.Any(line => line.GetPreferredWidth() == null);
            
            if (!gotLineWithNoLimit)
            {
                return this.content.Max(line => line.GetPreferredWidth() ?? 0);
            }

            return null;
        }

        public double? GetPreferredHeight()
        {
            var gotLineWithNoLimit = this.content.Any(line => line.GetPreferredHeight() == null);

            if (!gotLineWithNoLimit)
            {
                return this.content.Sum(line => line.GetPreferredHeight() ?? 0) + (this.lineSpacing * LuaMath.max(this.lines.Count - 1, 0));
            }

            return null;
        }

        public void SetPosition(IFrame parent, double xOff, double yOff, double width, double height)
        {
            height = this.GetPreferredHeight() ?? height;

            this.Frame.SetParent(parent);
            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);
            this.Frame.SetPoint(FramePoint.TOPLEFT, xOff, -yOff);

            var linesWithNoHeightLimit = this.content.Where(line => line.GetPreferredHeight() == null);
            var linesWithHeightLimit = this.content.Where(line => line.GetPreferredHeight() != null);

            double heightUsed = 0;
            linesWithHeightLimit.Foreach(line =>
            {
                heightUsed += line.GetPreferredHeight() ?? 0 + this.lineSpacing;
            });

            double heightPrFlexObject = 0;
            if (linesWithNoHeightLimit.Any())
            {
                var heightAvailable = height - heightUsed - (this.lineSpacing * (linesWithNoHeightLimit.Count - 1));
                heightPrFlexObject = heightAvailable / linesWithNoHeightLimit.Count;
            }

            heightUsed = 0;
            this.content.Foreach(line =>
            {
                var lineHeight = line.GetPreferredHeight() ?? heightPrFlexObject;
                line.SetPosition(this.Frame, 0, heightUsed, width, lineHeight);
                heightUsed += lineHeight + this.lineSpacing;
            });
        }

        public string Name { get; private set; }
    }
}