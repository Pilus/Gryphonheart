namespace CsLuaTest.Serialization
{
    using CsLua;
    using CsLua.Collection;
    using Lua;

    public class SerializationTests : BaseTest
    {

        public SerializationTests()
        {
            this.Tests["TestBasicSerializableClass"] = TestBasicSerializableClass;
            this.Tests["TestClassWithSubObject"] = TestClassWithSubObject;
            this.Tests["TestClassInCsLuaList"] = TestClassInCsLuaList;
        }

        private static void TestBasicSerializableClass()
        {
            var theClass = new ClassWithNativeObjects();

            var tableFormatter = new TableFormatter<ClassWithNativeObjects>();
            
            var res = tableFormatter.Serialize(theClass);
            var processedClass = tableFormatter.Deserialize(res);

            Assert(theClass.AString, processedClass.AString);
            Assert(theClass.ANumber, processedClass.ANumber);
        }

        private static void TestClassWithSubObject()
        {
            var theClass = new ClassWithSubObject();

            var tableFormatter = new TableFormatter<ClassWithSubObject>();

            var res = tableFormatter.Serialize(theClass);
            var processedClass = tableFormatter.Deserialize(res);

            Assert(theClass.AnArray[0], processedClass.AnArray[0]);
            Assert(theClass.AnArray[1], processedClass.AnArray[1]);
            Assert(theClass.AClass.AString, processedClass.AClass.AString);
            Assert(theClass.AClass.ANumber, processedClass.AClass.ANumber);
        }

        private static void TestClassInCsLuaList()
        {
            var theClass = new ClassWithNativeObjects();
            var list = new CsLuaList<ClassWithNativeObjects>()
            {
                theClass,
            };

            var tableFormatter = new TableFormatter<CsLuaList<ClassWithNativeObjects>>();

            var res = tableFormatter.Serialize(list);
            var processedClass = tableFormatter.Deserialize(res);

            Assert(1, processedClass.Count);
            Assert(theClass.AString, processedClass[0].AString);
            Assert(theClass.ANumber, processedClass[0].ANumber);
        }

        
    }
}