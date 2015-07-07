namespace Grinder.Presenter
{
    using CsLua.Collection;
    using View;

    public class EntitySelection : CsLuaDictionary<string, CsLuaList<ITrackableEntity>>, IEntitySelection
    {
         
    }
}