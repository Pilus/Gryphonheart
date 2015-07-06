
namespace CsLuaTest.Override
{
    class Level4 : Level3
    {
        public override void M()
        {
            OverrideTest.Output += "Level4M,";
        }

        public void Level4Base()
        {
            base.M();
        }

        public void Level4Self()
        {
            this.M();
        }
    }
}
