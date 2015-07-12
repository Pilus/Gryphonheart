namespace CsLuaTest.Wrap
{
    using System;
    using CsLua;
    using CsLua.Wrapping;

    class WrapTests : BaseTest
    {
        public WrapTests()
        {
            Name = "Wrap";
            this.Tests["WrapSimpleInterface"] = WrapSimpleInterface;
            this.Tests["WrapInheritingInterface"] = WrapInheritingInterface;
            this.Tests["WrapGenericInterface"] = WrapGenericInterface;
            this.Tests["WrapInheritingInterfaceWithGenericInterface"] = WrapInheritingInterfaceWithGenericInterface;
            this.Tests["WrapInheritingInterfaceWithProvideSelf"] = WrapInheritingInterfaceWithProvideSelf;
            this.Tests["WrapHandleMultipleValues"] = WrapHandleMultipleValues;
            this.Tests["WrapGenericWithProperty"] = WrapGenericWithProperty;
            this.Tests["WrapHandleMultipleValues"] = WrapHandleMultipleValues;
            this.Tests["WrapHandleRecursiveWrapping"] = WrapHandleRecursiveWrapping;
            this.Tests["WrapWithTargetTypeTranslation"] = WrapWithTargetTypeTranslation;
            this.Tests["CastOfWrappedObject"] = CastOfWrappedObject;
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

        public static void WrapGenericWithProperty()
        {
            if (!GameEnvironment.IsExecutingInGame)
            {
                return;
            }

            GameEnvironment.ExecuteLuaCode("interfaceImplementation = { Method = function() end, Property = { Value = 43, Method = function() end}, };");
            var interfaceImplementation = Wrapper.WrapGlobalObject<IInterfaceWithGenerics<ISimpleInterface>>("interfaceImplementation");

            var inner = interfaceImplementation.Property;
            Assert(43, inner.Value);
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

        public static void WrapHandleMultipleValues()
        {
            if (!GameEnvironment.IsExecutingInGame)
            {
                return;
            }

            GameEnvironment.ExecuteLuaCode("interfaceImplementation = { Method = function() return 'OK', 43, true; end, };");
            var interfaceImplementation = Wrapper.WrapGlobalObject<IInterfaceWithMultipleReturnValues<bool>>("interfaceImplementation");

            var multiple = interfaceImplementation.Method();
            Assert("OK", multiple.Value1);
            Assert(43, multiple.Value2);
            Assert(true, multiple.Value3);
        }

        public static void WrapHandleRecursiveWrapping()
        {
            if (!GameEnvironment.IsExecutingInGame)
            {
                return;
            }

            GameEnvironment.ExecuteLuaCode(@"
                local recursiveInterfaceGenerator = function(inner, value)
                    return {
                        GetInner = function() return inner; end,
                        Inner = inner,
                        GetValue = function() return value; end,
                        Property = true,
                    };
                end

                A = recursiveInterfaceGenerator(null, 'a');
                B = recursiveInterfaceGenerator(A, 'b');
                C = recursiveInterfaceGenerator(B, 'c');
            ");

            var C = Wrapper.WrapGlobalObject<IInterfaceWithWrappedValues>("C");
            Assert('c', C.GetValue());

            var B = C.Inner;
            Assert('b', B.GetValue());

            var A = B.GetInner();
            Assert('a', A.GetValue());
        }

        public static void WrapWithTargetTypeTranslation()
        {
            GameEnvironment.ExecuteLuaCode(@"
                retTrue = function() return true; end;

                A = {
                    IsBase = retTrue,
                    IsA = retTrue,
                }
                B = {
                    IsBase = retTrue,
                    IsB = retTrue,
                }

                P = {
                    Produce = function(s)
                        return _G[s];
                    end
                };
            ");

            var producer = Wrapper.WrapGlobalObject<IProducer>("P", false, table => "CsLuaTest.Wrap." + ((table["IsA"] != null) ? "IA" : "IB"));

            var a = producer.Produce("A");
            Assert(true, a is IA);
            Assert(true, ((IA)a).IsA());

            var b = (IB)producer.Produce("B");
            Assert(true, b.IsB());
        }

        public static void CastOfWrappedObject()
        {
            GameEnvironment.ExecuteLuaCode(@"
                retTrue = function() return true; end;

                A = {
                    IsBase = retTrue,
                    IsA = retTrue,
                }
                B = {
                    IsBase = retTrue,
                    IsB = retTrue,
                }

                P = {
                    Produce = function(s)
                        return _G[s];
                    end
                };
            ");

            var producer = Wrapper.WrapGlobalObject<IProducer>("P");

            var a = producer.Produce("A");
            var aCast = (IA) a;

            Assert(true, aCast is IA);
            Assert(true, aCast.IsA());
        }
    }
}
