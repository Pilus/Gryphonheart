using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CsLuaTest.Override
{
    class Level3 : Level2
    {
        public override void M()
        {
            OverrideTest.Output += "Level3M,";
        }

        public void Level3Base()
        {
            base.M();
        }

        public void Level3Self()
        {
            this.M();
        }
    }
}
