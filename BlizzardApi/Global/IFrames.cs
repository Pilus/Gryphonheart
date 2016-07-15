
namespace BlizzardApi.Global
{
    using WidgetInterfaces;

    public interface IFrames
    {
        IFrame UIParent { get; }
        IGameTooltip GameTooltip { get; }
    }
}
