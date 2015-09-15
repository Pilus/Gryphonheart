namespace GHF.Model.MSP
{
    using BlizzardApi.WidgetInterfaces;

    public interface IMSPFields
    {
        string this[string key] { get; set; }
    }
}