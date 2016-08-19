
namespace GH.CommonModules.QuickButtonCluster.ClusterButtonAnimation
{
    using Lua;

    public class AnimationBase
    {
        private const int MaxNumberOfButtons = 9;
        private const double StartingAngleInDeg = 135;

        private readonly double r;

        public AnimationBase(double r)
        {
            this.r = r;
        }


        protected double[] GetCoordinates(int numButton)
        {
            const int degreesPrButton = 360/MaxNumberOfButtons;
            var deg = StartingAngleInDeg - (degreesPrButton * numButton);
            return this.GetCircularCoordinates(deg);
        }

        private double[] GetCircularCoordinates(double degrees)
        {
            return new [] { this.r * LuaMath.cos(degrees), this.r * LuaMath.sin(degrees) };
        }
    }
}
