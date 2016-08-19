namespace GH.CommonModules.QuickButtonCluster
{
    using System.Collections.Generic;
    using GH.CommonModules.QuickButtonCluster.ClusterButtonAnimation;
    using GH.Settings;
    public class QuickButtonSettings : ISetting
    {
        public const SettingIds SettingId = SettingIds.QuickButtonSettings;

        public QuickButtonSettings()
        {
            this.QuickButtons = new List<IQuickButton>();
        }

        /// <summary>
        /// Gets the id of the entity.
        /// </summary>
        public SettingIds Id => SettingId;
        /// <summary>
        /// The X location coordinate of the button cluster from the top left of the screen.
        /// </summary>
        public double XLocation { get; set; }
        /// <summary>
        /// The Y location coordinate of the button cluster from the top left of the screen.
        /// </summary>
        public double YLocation { get; set; }

        /// <summary>
        /// List of quick buttons.
        /// </summary>
        public List<IQuickButton> QuickButtons { get; set; }

        public ClusterButtonAnimationType ShowAnimationType { get; set; }
        public ClusterButtonAnimationType HideAnimationType { get; set; }
    }
}