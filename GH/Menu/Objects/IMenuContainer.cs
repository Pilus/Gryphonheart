

namespace GH.Menu.Objects
{
    using BlizzardApi.WidgetInterfaces;

    public interface IMenuContainer
    {
        void ForceLabel(string label, object value);

        object GetLabel(string label);

        IMenuObject GetLabelFrame(string label);

        void RemoveElement(string label);

        IFrame Frame { get; }
    }
}
