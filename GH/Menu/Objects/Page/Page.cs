namespace GH.Menu.Objects.Page
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;
    using Debug;
    using Line;

    public class Page : IPage
    {
        public IFrame Frame { get; private set; }

        private readonly CsLuaList<ILine> lines;

        private readonly double lineSpacing;

        public Page(PageProfile profile, IFrame parent, LayoutSettings layoutSettings, int pageNumber)
        {
            this.lines = new CsLuaList<ILine>();
            this.Frame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, parent.GetName() + "Page" + pageNumber,
                parent);
            this.lineSpacing = layoutSettings.lineSpacing;

            profile.Foreach(lineProfile =>
            {
                this.lines.Add(new Line(lineProfile, this.Frame, layoutSettings, this.lines.Count + 1));
            });

            if (this.lines.Count == 0)
            {
                throw new MenuConfigurationException("The page does not contain any lines.");
            }

            this.Name = profile.name;

            //UiDebugTools.FrameBg(this.Frame);
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
            var gotLineWithNoLimit = this.lines.Any(line => line.GetPreferredWidth() == null);
            
            if (!gotLineWithNoLimit)
            {
                return this.lines.Max(line => line.GetPreferredWidth() ?? 0);
            }

            return null;
        }

        public double? GetPreferredHeight()
        {
            var gotLineWithNoLimit = this.lines.Any(line => line.GetPreferredHeight() == null);

            if (!gotLineWithNoLimit)
            {
                return this.lines.Sum(line => line.GetPreferredHeight() ?? 0) + (this.lines.Count > 0 ? this.lineSpacing : 0);
            }

            return null;
        }

        public void SetPosition(double xOff, double yOff, double width, double height)
        {
            height = this.GetPreferredHeight() ?? height;

            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);
            this.Frame.SetPoint(FramePoint.TOPLEFT, xOff, -yOff);

            var linesWithNoHeightLimit = this.lines.Where(line => line.GetPreferredHeight() == null);
            var linesWithHeightLimit = this.lines.Where(line => line.GetPreferredHeight() != null);

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
            this.lines.Foreach(line =>
            {
                var lineHeight = line.GetPreferredHeight() ?? heightPrFlexObject;
                line.SetPosition(0, heightUsed, width, lineHeight);
                heightUsed += lineHeight + this.lineSpacing;
            });
        }

        public IMenuObject GetFrameById(string id)
        {
            return this.lines.Select(line => line.GetFrameById(id))
                .FirstOrDefault(frame => frame != null);
        }

        public string Name { get; private set; }

        public void AddElement(int lineIndex, IObjectProfile profile)
        {
            throw new System.NotImplementedException();
        }

        public void SetValue(object value)
        {
            throw new CsException("Pages does not contain any value.");
        }

        public object GetValue()
        {
            throw new CsException("Pages cannot hold any values.");
        }

        public void RemoveElement(string label)
        {
            throw new System.NotImplementedException();
        }

        public ObjectAlign GetAlignment()
        {
            return ObjectAlign.c;
        }

        public double GetPreferredCenterX()
        {
            return 0;
        }

        public double GetPreferredCenterY()
        {
            return 0;
        }

        public void Clear()
        {
            this.lines.Foreach(line => line.Clear());
        }
    }
}