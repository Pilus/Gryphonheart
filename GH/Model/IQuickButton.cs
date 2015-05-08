﻿

namespace GH.Model
{
    using System;
    using GH.ObjectHandling;
    using Integration;

    public interface IQuickButton : IIdObject<string>
    {
        bool IsDefault { get; set; }

        string Icon { get; set; }

        string Tooltip { get; set; }

        Action Action { get; set; }

        int Order { get; set; }

        AddOnReference RequiredAddOn { get; set; }
    }
}