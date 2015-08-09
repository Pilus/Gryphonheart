namespace GHC.Modules.AbilityActionBar
{
    using System;
    using BlizzardApi.WidgetInterfaces;

    public interface IActionButtonProxyMethods
    {
        void CooldownFrame_SetTimer(IFrame self, double start, int duration, int enable, bool forceShowDrawEdge);
        void CooldownFrame_SetTimer(IFrame self, double start, int duration, int enable);
    }
}