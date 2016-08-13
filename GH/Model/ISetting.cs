
namespace GH.Model
{
    using GH.Utils.Entities;

    public interface ISetting : IIdEntity<SettingIds>
    {
        object Value { get; set; }
    }
}
