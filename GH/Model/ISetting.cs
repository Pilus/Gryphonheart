
namespace GH.Model
{
    using GH.ObjectHandling;

    public interface ISetting : IIdObject<SettingIds>
    {
        object Value { get; set; }
    }
}
