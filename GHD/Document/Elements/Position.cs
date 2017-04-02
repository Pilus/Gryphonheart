namespace GHD.Document.Elements
{
    public class Position
    {
        public Position(double x, double y)
        {
            this.X = x;
            this.Y = y;
        }

        public double X { get; set; }

        public double Y { get; set; }
    }
}