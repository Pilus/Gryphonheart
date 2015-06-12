namespace CsLuaTest.DefaultValues
{
    public class DefaultValuesTests : BaseTest
    {
        public DefaultValuesTests()
        {
            Name = "DefaultValues";
            this.Tests["DefaultInt"] = DefaultInt;
            this.Tests["DefaultBool"] = DefaultBool;
            this.Tests["DefaultString"] = DefaultString;
            this.Tests["DefaultEnum"] = DefaultEnum;
            this.Tests["DefaultAction"] = DefaultAction;
            this.Tests["DefaultFunc"] = DefaultFunc;
            this.Tests["DefaultClass"] = DefaultClass;
        }

        public static void DefaultInt()
        {
            Assert(0, DefaultValuesClass.StaticInt);
            Assert(0, new DefaultValuesClass().Int);
        }

        public static void DefaultBool()
        {
            Assert(false, DefaultValuesClass.StaticBool);
            Assert(false, new DefaultValuesClass().Bool);
        }

        public static void DefaultString()
        {
            Assert(null, DefaultValuesClass.StaticString);
            Assert(null, new DefaultValuesClass().String);
        }

        public static void DefaultEnum()
        {
            Assert(AnEnum.Something, DefaultValuesClass.StaticEnum);
            Assert(AnEnum.Something, new DefaultValuesClass().Enum);
        }

        public static void DefaultAction()
        {
            Assert(null, DefaultValuesClass.StaticAction);
            Assert(null, new DefaultValuesClass().AnAction);
        }

        public static void DefaultFunc()
        {
            Assert(null, DefaultValuesClass.StaticFunc);
            Assert(null, new DefaultValuesClass().AFunc);
        }

        public static void DefaultClass()
        {
            Assert(null, DefaultValuesClass.StaticClass);
            Assert(null, new DefaultValuesClass().AClass);
        }
    }
}