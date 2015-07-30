namespace WoWSimulator.UISimulation
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;

    public class GlobalFrames : IFrames
    {

        public IFrame UIParent { get; set; }

        public IGameTooltip GameTooltip { get; set; }
    }
}