namespace GHD.Document.AltElements
{
    public class HorizontalGroup : IGroup
    {
        private double constraint;

        public HorizontalGroup(double constraint)
        {
            this.constraint = constraint;
        }

        public VerticalGroup Group { get; set; }
    }
}