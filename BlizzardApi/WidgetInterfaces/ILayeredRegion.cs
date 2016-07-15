namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;
    using WidgetEnums;

    [ProvideSelf]
    public interface ILayeredRegion : IRegion
    {
        /// <summary>
        /// Returns the draw layer for the Region
        /// </summary>
        /// <returns>Draw layer</returns>
        DrawLayer GetDrawLayer();
        /// <summary>
        /// Sets the draw layer for the Region
        /// </summary>
        /// <param name="layer">Draw layer</param>
        void SetDrawLayer(DrawLayer layer);

        void SetVertexColor(double r, double g, double b);
        void SetVertexColor(double r, double g, double b, double alpha);
    }
}