
namespace GH.Model
{
    using GH.Utils.Entities;

    public interface ISetting : IIdObject<SettingIds>
    {
        object Value { get; set; }
    }
}
