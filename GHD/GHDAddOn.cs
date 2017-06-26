
namespace GHD
{
    using Model;
    using CsLuaFramework;
    using CsLuaFramework.Attributes;

    [CsLuaAddOn("GHD", "Gryphonheart Documents", 70200, Author = "The Gryphonheart Team")]
    public class GHDAddOn : ICsLuaAddOn
    {
        public void Execute()
        {
            new ModelProvider();
        }
    }
}
