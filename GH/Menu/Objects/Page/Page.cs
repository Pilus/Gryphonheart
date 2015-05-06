namespace GH.Menu.Objects.Page
{
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;
    using Line;

    public class Page : IPage
    {
        public IFrame Frame { get; private set; }

        private readonly CsLuaList<ILine> lines;

        private readonly double lineSpacing;

        public Page(PageProfile profile, IFrame parent, LayoutSettings layoutSettings, int pageNumber)
        {
            this.lines = new CsLuaList<ILine>();
            this.Frame = (IFrame) FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, parent.GetName() + "Page" + pageNumber,
                parent);
            this.lineSpacing = layoutSettings.lineSpacing;

            profile.Foreach(lineProfile =>
            {
                this.lines.Add(new Line(lineProfile, this.Frame, layoutSettings, this.lines.Count + 1));
            });

            this.Name = profile.name;
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

            double width = 0;

            if (!gotLineWithNoLimit)
            {
                width = this.lines.Max(line => line.GetPreferredWidth() ?? 0);
            }

            return width;
        }

        public double? GetPreferredHeight()
        {
            var gotLineWithNoLimit = this.lines.Any(line => line.GetPreferredHeight() == null);

            double height = 0;

            if (!gotLineWithNoLimit)
            {
                height = this.lines.Sum(line => line.GetPreferredHeight() ?? 0) + (this.lines.Count > 0 ? this.lineSpacing : 0);
            }

            return height;
        }

        public void SetPosition(double xOff, double yOff, double width, double height)
        {
            width = this.GetPreferredWidth() ?? width;
            height = this.GetPreferredHeight() ?? height;

            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);

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
                var h = this.GetPreferredHeight() ?? heightPrFlexObject;
                line.SetPosition(0, heightUsed, width, h);
                heightUsed += h + this.lineSpacing;
            });
        }

        public IMenuObject GetLabelFrame(string label)
        {
            return this.lines.Select(line => line.GetLabelFrame(label))
                .FirstOrDefault(labelFrame => labelFrame != null);
        }

        public string Name { get; private set; }

        public void AddElement(int lineIndex, IObjectProfile profile)
        {
            throw new System.NotImplementedException();
        }

        public void ForceLabel(string label, object value)
        {
            throw new System.NotImplementedException();
        }

        public object GetLabel(string label)
        {
            throw new System.NotImplementedException();
        }

        public void RemoveElement(string label)
        {
            throw new System.NotImplementedException();
        }



    }
}