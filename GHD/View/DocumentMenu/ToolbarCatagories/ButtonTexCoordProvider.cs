
namespace GHD.View.DocumentMenu.ToolbarCatagories
{
    public static class ButtonTexCoordProvider
    {
        private const double FractionPrIcon = 0.25;

        public static double[] GetTexCoord(int x, int y)
        {
            var l = (x-1) * FractionPrIcon;
		    var r = x * FractionPrIcon;
		    var t = (y-1) * FractionPrIcon;
		    var b = y * FractionPrIcon;
            return new [] { l, t, l, b, r, t, r, b };
        }
    }
}
