namespace TestUtils
{
    using System.Linq;
    using CsLuaFramework.Wrapping;
    using Lua;
    using Moq;

    public class TestUtil
    {
        public static T GetTableValue<T>(NativeLuaTable t, params object[] indexes)
        {
            var value = t[indexes[0]];
            if (indexes.Length == 1)
            {
                return (T)value;
            }
            return GetTableValue<T>((NativeLuaTable) value, indexes.Skip(1).ToArray());
        }


        public static IMultipleValues<T1, T2> StructureMultipleValues<T1, T2>(T1 value1, T2 value2)
        {
            var mock = new Mock<IMultipleValues<T1, T2>>();

            mock.SetupGet(x => x.Value1).Returns(value1);
            mock.SetupGet(x => x.Value2).Returns(value2);

            return mock.Object;
        }

        public static IMultipleValues<T1, T2, T3> StructureMultipleValues<T1, T2, T3>(T1 value1, T2 value2, T3 value3)
        {
            var mock = new Mock<IMultipleValues<T1, T2, T3>>();

            mock.SetupGet(x => x.Value1).Returns(value1);
            mock.SetupGet(x => x.Value2).Returns(value2);
            mock.SetupGet(x => x.Value3).Returns(value3);

            return mock.Object;
        }

        public static IMultipleValues<T1, T2, T3, T4> StructureMultipleValues<T1, T2, T3, T4>(T1 value1, T2 value2, T3 value3, T4 value4)
        {
            var mock = new Mock<IMultipleValues<T1, T2, T3, T4>>();

            mock.SetupGet(x => x.Value1).Returns(value1);
            mock.SetupGet(x => x.Value2).Returns(value2);
            mock.SetupGet(x => x.Value3).Returns(value3);
            mock.SetupGet(x => x.Value4).Returns(value4);

            return mock.Object;
        }

        public static IMultipleValues<T1, T2, T3, T4, T5> StructureMultipleValues<T1, T2, T3, T4, T5>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5)
        {
            var mock = new Mock<IMultipleValues<T1, T2, T3, T4, T5>>();

            mock.SetupGet(x => x.Value1).Returns(value1);
            mock.SetupGet(x => x.Value2).Returns(value2);
            mock.SetupGet(x => x.Value3).Returns(value3);
            mock.SetupGet(x => x.Value4).Returns(value4);
            mock.SetupGet(x => x.Value5).Returns(value5);

            return mock.Object;
        }

        public static IMultipleValues<T1, T2, T3, T4, T5, T6> StructureMultipleValues<T1, T2, T3, T4, T5, T6>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6)
        {
            var mock = new Mock<IMultipleValues<T1, T2, T3, T4, T5, T6>>();

            mock.SetupGet(x => x.Value1).Returns(value1);
            mock.SetupGet(x => x.Value2).Returns(value2);
            mock.SetupGet(x => x.Value3).Returns(value3);
            mock.SetupGet(x => x.Value4).Returns(value4);
            mock.SetupGet(x => x.Value5).Returns(value5);
            mock.SetupGet(x => x.Value6).Returns(value6);

            return mock.Object;
        }

        public static IMultipleValues<T1, T2, T3, T4, T5, T6, T7> StructureMultipleValues<T1, T2, T3, T4, T5, T6, T7>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6, T7 value7)
        {
            var mock = new Mock<IMultipleValues<T1, T2, T3, T4, T5, T6, T7>>();

            mock.SetupGet(x => x.Value1).Returns(value1);
            mock.SetupGet(x => x.Value2).Returns(value2);
            mock.SetupGet(x => x.Value3).Returns(value3);
            mock.SetupGet(x => x.Value4).Returns(value4);
            mock.SetupGet(x => x.Value5).Returns(value5);
            mock.SetupGet(x => x.Value6).Returns(value6);
            mock.SetupGet(x => x.Value7).Returns(value7);

            return mock.Object;
        }

        public static IMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8> StructureMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6, T7 value7, T8 value8)
        {
            var mock = new Mock<IMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8>>();

            mock.SetupGet(x => x.Value1).Returns(value1);
            mock.SetupGet(x => x.Value2).Returns(value2);
            mock.SetupGet(x => x.Value3).Returns(value3);
            mock.SetupGet(x => x.Value4).Returns(value4);
            mock.SetupGet(x => x.Value5).Returns(value5);
            mock.SetupGet(x => x.Value6).Returns(value6);
            mock.SetupGet(x => x.Value7).Returns(value7);
            mock.SetupGet(x => x.Value8).Returns(value8);

            return mock.Object;
        }

        public static IMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8, T9> StructureMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8, T9>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6, T7 value7, T8 value8, T9 value9)
        {
            var mock = new Mock<IMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8, T9>>();

            mock.SetupGet(x => x.Value1).Returns(value1);
            mock.SetupGet(x => x.Value2).Returns(value2);
            mock.SetupGet(x => x.Value3).Returns(value3);
            mock.SetupGet(x => x.Value4).Returns(value4);
            mock.SetupGet(x => x.Value5).Returns(value5);
            mock.SetupGet(x => x.Value6).Returns(value6);
            mock.SetupGet(x => x.Value7).Returns(value7);
            mock.SetupGet(x => x.Value8).Returns(value8);
            mock.SetupGet(x => x.Value9).Returns(value9);

            return mock.Object;
        }

        public static IMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> StructureMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6, T7 value7, T8 value8, T9 value9, T10 value10)
        {
            var mock = new Mock<IMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>>();

            mock.SetupGet(x => x.Value1).Returns(value1);
            mock.SetupGet(x => x.Value2).Returns(value2);
            mock.SetupGet(x => x.Value3).Returns(value3);
            mock.SetupGet(x => x.Value4).Returns(value4);
            mock.SetupGet(x => x.Value5).Returns(value5);
            mock.SetupGet(x => x.Value6).Returns(value6);
            mock.SetupGet(x => x.Value7).Returns(value7);
            mock.SetupGet(x => x.Value8).Returns(value8);
            mock.SetupGet(x => x.Value9).Returns(value9);
            mock.SetupGet(x => x.Value10).Returns(value10);

            return mock.Object;
        }

        public static IMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> StructureMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6, T7 value7, T8 value8, T9 value9, T10 value10, T11 value11)
        {
            var mock = new Mock<IMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>>();

            mock.SetupGet(x => x.Value1).Returns(value1);
            mock.SetupGet(x => x.Value2).Returns(value2);
            mock.SetupGet(x => x.Value3).Returns(value3);
            mock.SetupGet(x => x.Value4).Returns(value4);
            mock.SetupGet(x => x.Value5).Returns(value5);
            mock.SetupGet(x => x.Value6).Returns(value6);
            mock.SetupGet(x => x.Value7).Returns(value7);
            mock.SetupGet(x => x.Value8).Returns(value8);
            mock.SetupGet(x => x.Value9).Returns(value9);
            mock.SetupGet(x => x.Value10).Returns(value10);
            mock.SetupGet(x => x.Value11).Returns(value11);

            return mock.Object;
        }
    }
}