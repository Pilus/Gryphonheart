
namespace GH.Menu.Objects
{
    public interface IObjectProfile
    {
        string type { get; }
        string label { get; set; }
        ObjectAlign align { get; set; }

    }
}
