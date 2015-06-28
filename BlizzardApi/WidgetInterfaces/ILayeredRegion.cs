namespace BlizzardApi.WidgetInterfaces
{
    using CsLua.Attributes;

    [ProvideSelf]
    public interface ILayeredRegion : IRegion
    {
        /// <summary>
        /// Returns the draw layer for the Region
        /// </summary>
        /// <returns>Draw layer</returns>
        object GetDrawLayer();
        /// <summary>
        /// Sets the draw layer for the Region
        /// </summary>
        /// <param name="layer">Draw layer</param>
        void SetDrawLayer(object layer);

        void SetVertexColor(float r, float g, float b);
        void SetVertexColor(float r, float g, float b, float alpha);
    }
}