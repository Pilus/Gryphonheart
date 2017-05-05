namespace GHD.Document.Groups
{
    using BlizzardApi.Global;
    using GHD.Document.Elements;

    public class HorizontalGroup : IGroup
    {
        public double WidthConstraint { get; }

        public double HeightConstraint { get; }

        public double Offset { get; }

        public HorizontalGroup(double widthConstraint, double heightConstraint, double offset)
        {
            this.WidthConstraint = widthConstraint;
            this.HeightConstraint = heightConstraint;
            this.Offset = offset;
        }

        public VerticalGroup Group { get; set; }
        

        public IElement FirstElement { get; set; }
        public IElement LastElement { get; set; }
    }
}