namespace Grinder.Presenter
{
    using CsLua.Collection;
    using Grinder.Model.Entity;
    using Model;
    using View;

    public class Presenter
    {
        private CsLuaDictionary<IEntityId, IEntitySample> initialTrackingSample;
        private IModel model;
        private IView view;

        public Presenter(IModel model, IView view)
        {
            this.initialTrackingSample = new CsLuaDictionary<IEntityId, IEntitySample>();
            this.model = model;
            this.view = view;

            this.view.SetUpdateAction(this.UpdateVelocity);

            this.LoadEntities();
        }

        private void LoadEntities()
        {
            this.model.LoadTrackedEntities().Foreach(AddEntity);
        }

        private void AddEntity(IEntity entity)
        {
            var id = GetId(entity);
            this.initialTrackingSample[id] = this.model.GetCurrentSample(id.Type, id.Id);
            this.view.AddTrackingEntity(id, entity.Name, entity.IconPath);
        }

        private static IEntityId GetId(IEntity entity)
        {
            return new EntityId(entity.Type, entity.Id);
        }

        private void UpdateVelocity()
        {
            foreach (var entityId in this.initialTrackingSample.Keys)
            {
                var intialSample = this.initialTrackingSample[entityId];
                var currentSample = this.model.GetCurrentSample(entityId.Type, entityId.Id);
                this.view.UpdateTrackingEntityVelocity(entityId, currentSample.Amount, GetVelocity(intialSample, currentSample));
            }
        }

        private static double GetVelocity(IEntitySample initialSample, IEntitySample currentSample)
        {
            var deltaA = currentSample.Amount - initialSample.Amount;
            var deltaT = (currentSample.Timestamp - initialSample.Timestamp) / (60*60);
            if (deltaT > 0)
            {
                return deltaA / deltaT;
            }

            return 0;
        }
    }
}