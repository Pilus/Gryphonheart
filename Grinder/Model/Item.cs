namespace Grinder.Model
{
    using CsLua.Wrapping;

    public class Item : IEntity
    {

        public Item(int id, IMultipleValues<string, string, int, int, int, string, string, int, string, string, int> currencyInfo)
        {
            this.Id = id;
            this.Name = currencyInfo.Value1;
            this.IconPath = currencyInfo.Value10;
            this.StackSize = currencyInfo.Value8;
        }

        public int Id { get; private set; }

        public EntityType Type
        {
            get { return EntityType.Item; }
        }

        public string Name { get; private set; }

        public string IconPath { get; private set; }

        public int StackSize { get; private set; }
    }
}