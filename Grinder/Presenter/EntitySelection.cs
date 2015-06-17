namespace Grinder.Presenter
{
    using System.Collections.Generic;
    using CsLua.Collection;
    using View;

    public class EntitySelection : CsLuaDictionary<string, CsLuaList<ITrackableEntity>>, IEntitySelection
    {
         
    }
}