namespace CsLuaTest.Serialization
{
    using CsLua.Collection;
    using Lua;

    public class SerializationTests : BaseTest
    {

        public SerializationTests()
        {
            Name = "Serialization";
            this.Tests["TestBasicSerializableClass"] = TestBasicSerializableClass;
            this.Tests["TestClassWithSubObject"] = TestClassWithSubObject;
            this.Tests["TestClassInCsLuaList"] = TestClassInCsLuaList;
            this.Tests["TestSerializeDictionary"] = TestSerializeDictionary;
        }

        private static void TestBasicSerializableClass()
        {
            var theClass = new ClassWithNativeObjects();

            var tableFormatter = new TableFormatter<ClassWithNativeObjects>();
            
            var res = tableFormatter.Serialize(theClass);

            Assert(theClass.AString, res["AString"]);
            Assert(theClass.ANumber, res["ANumber"]);
            Assert("CsLuaTest.Serialization.ClassWithNativeObjects", res["__type"]);

            var processedClass = tableFormatter.Deserialize(res);

            Assert(theClass.AString, processedClass.AString);
            Assert(theClass.ANumber, processedClass.ANumber);
        }

        private static void TestClassWithSubObject()
        {
            var theClass = new ClassWithSubObject();

            var tableFormatter = new TableFormatter<ClassWithSubObject>();

            var res = tableFormatter.Serialize(theClass);

            Assert("CsLuaTest.Serialization.ClassWithSubObject", res["__type"]);
            var arrayRes = res["AnArray"] as NativeLuaTable;
            //Assert("System.String[]", arrayRes["__type"]);
            Assert(theClass.AnArray[0], arrayRes[0]);
            Assert(theClass.AnArray[1], arrayRes[1]);

            var subRes = res["AClass"] as NativeLuaTable;
            Assert("CsLuaTest.Serialization.ClassWithNativeObjects", subRes["__type"]);
            Assert(theClass.AClass.AString, subRes["AString"]);
            Assert(theClass.AClass.ANumber, subRes["ANumber"]);

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

            Assert(1, res["__size"]);
            var subRes = res[0] as NativeLuaTable;
            Assert(theClass.AString, subRes["AString"]);
            Assert(theClass.ANumber, subRes["ANumber"]);

            var processedClass = tableFormatter.Deserialize(res);

            Assert(1, processedClass.Count);
            var res1 = processedClass[0];
            Assert(theClass.AString, res1.AString);

            var res2 = processedClass[0].AString;
            Assert(theClass.AString, res2);
            Assert(theClass.ANumber, processedClass[0].ANumber);
        }

        private static void TestSerializeDictionary()
        {
            var dict = new CsLuaDictionary<object, object>()
            {
                { 43, "something" },
                { "an index", "Someting else" }
            };

            var tableFormatter = new TableFormatter<CsLuaDictionary<object, object>>();

            var res = tableFormatter.Serialize(dict);

            Assert(dict[43], res[43]);
            Assert(dict["an index"], res["an index"]);

            var processedDict = tableFormatter.Deserialize(res);

            Assert(dict[43], processedDict[43]);
            Assert(dict["an index"], processedDict["an index"]);
        }
    }
}