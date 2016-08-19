namespace GH.CommonModules.QuickButtonCluster
{
    using System;
    using GH.Utils.AddOnIntegration;

    [Serializable]
    public class QuickButton : IQuickButton
    {
        public QuickButton(string id, int order, bool isDefault, string tooltip, string icon, Action action, AddOnReference requiredAddOn)
        {
            this.Id = id;
            this.Order = order;
            this.IsDefault = isDefault;
            this.Tooltip = tooltip;
            this.Icon = icon;
            this.Action = action;
            this.RequiredAddOn = requiredAddOn;
        }

        public bool IsDefault { get; set; }

        public string Icon { get; set; }

        public string Tooltip { get; set; }

        public Action Action { get; set; }
        public string Id { get; private set; }

        public int Order { get; set; }

        public AddOnReference RequiredAddOn { get; set; }
    }
}