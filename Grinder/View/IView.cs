
namespace Grinder.View
{
    using System;

    public interface IView
    {
        void SetUpdateAction(Action update);
        void SetTrackButtonOnClick(Action clickAction);
        void ShowEntitySelection(IEntitySelection selction);
        void SetTrackingEntityHandlers(Action<IEntityId> onReset, Action<IEntityId> onRemove);
        void AddTrackingEntity(IEntityId id, string name, string icon);
        void RemoveTrackingEntity(IEntityId id);
        void UpdateTrackingEntityVelocity(IEntityId id, int count, double velocity);
        
    }
}
