using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CsLuaTest.Generics
{
    class ClassWithGenericElements<T>
    {
        public T Variable;

        public T Property { get; set; }
    }
}
