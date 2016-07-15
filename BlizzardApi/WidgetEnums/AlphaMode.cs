namespace BlizzardApi.WidgetEnums
{
    public enum AlphaMode
    {
        DISABLE, // - opaque texture
        BLEND, // - normal painting on top of the background, obeying alpha channels if present in the image (uses alpha)
        ALPHAKEY, // - one-bit alpha
        ADD, // - additive blend
        MOD, // - modulating blend
    }
}