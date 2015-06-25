namespace Grinder.Model.EntityAdaptor
{
    using Entity;

    public class EntityAdaptorFactory : IEntityAdaptorFactory
    {
        public IEntityAdaptor CreateAdoptor(EntityType type)
        {
            switch (type)
            {
                case EntityType.Currency:
                    return new CurrencyAdaptor();
                case EntityType.Item:
                    return new ItemAdaptor();
            }

            throw new EntityAdaptorException(string.Format("No adaptor known for entity type {0}.", type));
        }
    }
}
