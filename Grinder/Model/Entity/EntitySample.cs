namespace Grinder.Model.Entity
{
    public class EntitySample : IEntitySample
    {
        public EntitySample(int amount, double timestamp)
        {
            this.Amount = amount;
            this.Timestamp = timestamp;
        }

        public int Amount { get; private set; }
        public double Timestamp { get; private set; }
    }
}