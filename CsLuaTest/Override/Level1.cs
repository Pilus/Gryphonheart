
namespace CsLuaTest.Override
{
    class Level1
    {
        public virtual void M()
        {
            OverrideTest.Output += "Level1M,";
        }

        public void Level1Self()
        {
            this.M();
        }
    }
}
