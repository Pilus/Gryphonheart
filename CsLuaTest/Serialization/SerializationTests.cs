namespace CsLuaTest.Serialization
{
    using CsLua;
    using CsLua.Collection;
    using Lua;

    public class SerializationTests : BaseTest
    {

        public override void PerformTests()
        {
            TestBasicSerializableClass();
            TestClassWithSubObject();
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

        
    }
}