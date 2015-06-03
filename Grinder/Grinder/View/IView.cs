
namespace Grinder.View
{
    using System;

    public interface IView
    {
        void SetUpdateAction(Action update);
        void SetTrackButtonOnClick(Action clickAction);
        void SetTrackingEntityDetails(string id, string name, string icon);
        void SetTrackingEntityHandler(string id, Action onReset, Action onRemove);
        void UpdateTrackingEntityVelocity(string id, double velocity);
        void RemoveTrackingEntity(string id);
    }
}
