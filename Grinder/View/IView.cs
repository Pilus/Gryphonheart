
namespace Grinder.View
{
    using System;

    public interface IView
    {
        void AddTrackingEntity(IEntityId id, string name, string icon);
        void RemoveTrackingEntity(IEntityId id);
        void SetUpdateAction(Action update);
        void SetTrackButtonOnClick(Action clickAction);
        void ShowEntitySelection(IEntitySelection selection);
        void SetTrackingEntityHandlers(Action<IEntityId> onReset, Action<IEntityId> onRemove);
        void UpdateTrackingEntityVelocity(IEntityId id, int count, double velocity);
    }
}
