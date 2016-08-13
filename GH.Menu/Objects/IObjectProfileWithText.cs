
namespace GH.Menu.Objects
{
    public interface IObjectProfileWithText : IObjectProfile
    {
        string text { get; set; }

        string tooltip { get; set; }
    }
}
