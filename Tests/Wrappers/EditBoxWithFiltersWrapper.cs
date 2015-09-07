namespace Tests.Wrappers
{
    using BlizzardApi.WidgetInterfaces;
    using GH.Menu.Objects.EditBox;
    using WoWSimulator.UISimulation;
    using WoWSimulator.UISimulation.UiObjects;

    public class EditBoxWithFiltersWrapper : EditBox, IEditBoxWithFilters
    {
        public static IUIObject Init(UiInitUtil util, LayoutFrameType layout, IRegion parent)
        {
            return new EditBoxWithFiltersWrapper(util, layout, parent);
        }

        public EditBoxWithFiltersWrapper(UiInitUtil util, LayoutFrameType layout, IRegion parent)
            : base(util, "editbox", layout as FrameType, parent)
        { }

        public bool VariablesOnly { get; set; }
        public bool NumbersOnly { get; set; }
    }
}