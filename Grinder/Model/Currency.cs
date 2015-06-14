namespace Grinder.Model
{
    using CsLua.Wrapping;

    public class Currency : IEntity
    {
        public Currency(int id, IMultipleValues<string, int, string, int, int, int, bool> currencyInfo)
        {
            this.Id = id;
            this.Name = currencyInfo.Value1;
            this.IconPath = currencyInfo.Value3;
            this.IsDiscovered = currencyInfo.Value7;
        }

        public int Id { get; private set; }

        public EntityType Type
        {
            get { return EntityType.Currency; }
        }

        public string Name { get; private set; }

        public string IconPath { get; private set; }

        public bool IsDiscovered { get; private set; }
    }
}