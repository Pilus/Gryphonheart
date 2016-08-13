namespace GH.Menu.Containers
{
    using System.Collections.Generic;

    public interface IContainerProfile<T> : IList<T>, IElementProfile
    {
    }
}
