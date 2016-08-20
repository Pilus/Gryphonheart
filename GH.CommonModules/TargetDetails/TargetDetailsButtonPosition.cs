namespace GH.CommonModules.TargetDetails
{
    using System.Security.Permissions;

    using GH.Settings;
    public class TargetDetailsButtonPosition : ISetting
    {
        public const SettingIds SettingId = SettingIds.TargetDetailsButtonPosition;

        public SettingIds Id => SettingId;

        public double XPosition { get; set; }
        public double YPosition { get; set; }
    }
}