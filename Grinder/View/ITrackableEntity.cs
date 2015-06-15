namespace Grinder.View
{
    using System;
    public interface ITrackableEntity
    {
        string Name { get; }
        string IconPath { get; }
        Action OnSelect { get; }
    }
}
