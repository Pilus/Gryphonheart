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
        public void UpdateLayout(IElement first, IElement last)
        {
            throw new System.NotImplementedException();
        }
    }
}