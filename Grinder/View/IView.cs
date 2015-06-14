
namespace Grinder.View
{
    using System;
    using CsLua.Collection;
    using Model;

    public interface IView
    {
        void SetUpdateAction(Action update);
        void SetTrackButtonOnClick(Action clickAction);
        void ShowEntitySelection(EntityType[] types, CsLuaList<IEntity> entities, Action<int> onSelect);
        void SetTrackingEntityHandlers(Action<int> onReset, Action<int> onRemove);
        void AddTrackingEntity(string id, string name, string icon);
        void RemoveTrackingEntity(string id);
        void UpdateTrackingEntityVelocity(string id, int count, double velocity);
        
    }
}
