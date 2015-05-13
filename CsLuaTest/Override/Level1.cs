using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
