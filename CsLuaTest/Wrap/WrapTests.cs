namespace CsLuaTest.Wrap
{
    using System;
    using CsLua;

    class WrapTests : BaseTest
    {
        public WrapTests()
        {
            this.Tests["WrapSimpleInterface"] = WrapSimpleInterface;
            this.Tests["WrapInheritingInterface"] = WrapInheritingInterface;
            this.Tests["WrapGenericInterface"] = WrapGenericInterface;
            this.Tests["WrapInheritingInterfaceWithGenericInterface"] = WrapInheritingInterfaceWithGenericInterface;
        }

        private static void WrapSimpleInterface()
        {
            if (!GameEnvironment.IsExecutingInGame)
            {
                return;
            }

            GameEnvironment.ExecuteLuaCode("interfaceImplementation = { Method = function(str) return 'OK' .. str; end, Value = 10, };");
            var interfaceImplementation = Wrapper.WrapGlobalObject<ISimpleInterface>("interfaceImplementation");

            Assert("OKInput", interfaceImplementation.Method("Input"));
            Assert(10, interfaceImplementation.Value);

            interfaceImplementation.Value = 20;
            Assert(20, interfaceImplementation.Value);
        }

        public static void WrapGenericInterface()
        {
            if (!GameEnvironment.IsExecutingInGame)
            {
                return;
            }

            GameEnvironment.ExecuteLuaCode("interfaceImplementation = { Method = function(n) return 'OK' .. n; end, };");
            var interfaceImplementation = Wrapper.WrapGlobalObject<IInterfaceWithGenerics<int>>("interfaceImplementation");

            Assert("OK10", interfaceImplementation.Method(10));
        }

        private static void WrapInheritingInterface()
        {
            if (!GameEnvironment.IsExecutingInGame)
            {
                return;
            }

            GameEnvironment.ExecuteLuaCode("interfaceImplementation = { Method = function(str) return 'OK' .. str; end, Value = 10, };");
            var interfaceImplementation = Wrapper.WrapGlobalObject<IInheritingInterface>("interfaceImplementation");

            Assert("OKInput", interfaceImplementation.Method("Input"));
            Assert(10, interfaceImplementation.Value);

            interfaceImplementation.Value = 20;
            Assert(20, interfaceImplementation.Value);
        }

        public static void WrapInheritingInterfaceWithGenericInterface()
        {
            if (!GameEnvironment.IsExecutingInGame)
            {
                return;
            }

            GameEnvironment.ExecuteLuaCode("interfaceImplementation = { Method = function(n) return 'OK' .. n; end, };");
            var interfaceImplementation = Wrapper.WrapGlobalObject<IInheritingInterfaceWithGenerics<string,int>>("interfaceImplementation");

            Assert("OK10", interfaceImplementation.Method(10));
        }

        public static void WrapInheritingInterfaceWithProvideSelf()
        {
            if (!GameEnvironment.IsExecutingInGame)
            {
                return;
            }

            GameEnvironment.ExecuteLuaCode("interfaceImplementation = { Method = function(self, str) return 'OK' .. str; end, };");
            var interfaceImplementation = Wrapper.WrapGlobalObject<ISetSelfInterface>("interfaceImplementation");

            Assert("OKmore", interfaceImplementation.Method("more"));
        }
    }
}
