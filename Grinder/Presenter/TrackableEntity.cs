namespace Grinder.Presenter
{
    using System;
    using Model.Entity;
    using View;

    public class TrackableEntity : ITrackableEntity
    {
        public TrackableEntity(IEntity entity, Action<IEntity> track)
        {
            this.Name = entity.Name;
            this.IconPath = entity.IconPath;
            this.OnSelect = () =>
            {
                track(entity);
            };
        }

        public string Name { get; private set; }

        public string IconPath { get; private set; }

        public Action OnSelect { get; private set; }
    }
}