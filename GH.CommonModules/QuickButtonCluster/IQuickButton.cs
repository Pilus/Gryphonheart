﻿

namespace GH.CommonModules.QuickButtonCluster
{
    using System;
    using GH.Utils.AddOnIntegration;
    using GH.Utils.Entities;

    public interface IQuickButton : IIdEntity<string>
    {
        bool IsDefault { get; set; }

        string Icon { get; set; }

        string Tooltip { get; set; }

        Action Action { get; set; }

        int Order { get; set; }

        AddOnReference RequiredAddOn { get; set; }
    }
}
