namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;
    using CsLuaFramework.Wrapping;
    using WidgetEnums;

    [ProvideSelf]
    public interface ITexture : ILayeredRegion, IUIObject
    {
        /// <summary>
        /// Return the blend mode set by SetBlendMode()
        /// </summary> 
        AlphaMode GetBlendMode();
        /// <summary>
        /// Gets the 8 texture coordinates that map to the Texture's corners (added 1.11)
        /// </summary>
        /// <returns></returns>
        IMultipleValues<double, double, double, double, double, double, double, double> GetTexCoord();
        /// <summary>
        /// Gets this texture's current texture path.
        /// </summary>
        /// <returns></returns>
        string GetTexture();
        /// <summary>
        /// Gets the vertex color for the Texture.
        /// </summary>
        /// <returns></returns>
        IMultipleValues<double, double, double, double> GetVertexColor();
        /// <summary>
        /// Gets the desaturation state of this Texture. (added 1.11)
        /// </summary>
        /// <returns></returns>
        int IsDesaturated();
        /// <summary>
        /// Set the alphaMode of the texture.
        /// </summary>
        /// <param name="mode"></param>
        void SetBlendMode(AlphaMode mode);
        /// <summary>
        /// If should be displayed with no saturation. has a return value.
        /// </summary>
        /// <param name="flag"></param>
        /// <returns></returns>
        bool SetDesaturated(int flag);

        void SetGradient(Orientation orientation, double minR, double minG, double minB, double maxR, double maxG, double maxB);

        void SetGradientAlpha(Orientation orientation, double minR, double minG, double minB, double minA, double maxR, double maxG,
            double maxB, double maxA);
        /// <summary>
        /// Shorthand for the appropriate 8 argument SetTexCoord rotation (in C++ so it's fast)
        /// </summary>
        /// <param name="angle"></param>
        void SetRotation(double angle);
        /// <summary>
        /// Shorthand for the appropriate 8 argument SetTexCoord rotation (in C++ so it's fast)
        /// </summary>
        /// <param name="angle"></param>
        /// <param name="cx"></param>
        /// <param name="cy"></param>
        void SetRotation(double angle, double cx, double cy);

        void SetTexCoord(double minX, double maxX, double minY, double maxY);

        void SetTexCoord(double ULx, double ULy, double LLx, double LLy, double URx, double URy, double LRx, double LRy);
        /// <summary>
        /// Sets the texture to be displayed from a file or to a solid color.
        /// </summary>
        /// <param name="texturePath"></param>
        void SetTexture(string texturePath);
        /// <summary>
        /// Sets the texture to be displayed from a file or to a solid color.
        /// </summary>
        /// <param name="r"></param>
        /// <param name="g"></param>
        /// <param name="b"></param>
        void SetTexture(double r, double g, double b);
        /// <summary>
        /// Sets the texture to be displayed from a file or to a solid color.
        /// </summary>
        /// <param name="r"></param>
        /// <param name="g"></param>
        /// <param name="b"></param>
        /// <param name="a"></param>
        void SetTexture(double r, double g, double b, double a);
    }
}