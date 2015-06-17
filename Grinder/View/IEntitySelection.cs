
namespace Grinder.View
{
    using System.Collections.Generic;
    using CsLua.Collection;

    public interface IEntitySelection : IDictionary<string, CsLuaList<ITrackableEntity>>
    {
    }
}
