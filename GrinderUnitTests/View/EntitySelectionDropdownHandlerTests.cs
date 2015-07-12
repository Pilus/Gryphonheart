using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace GrinderUnitTests.View
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using Grinder.Presenter;
    using Grinder.View;
    using Lua;
    using Moq;

    [TestClass]
    public class EntitySelectionDropdownHandlerTests
    {
        [TestMethod]
        public void DropdownHandlerShowsEntitySelection()
        {
            var anchorMock = new Mock<IFrame>();

            var uiParent = new Mock<IFrame>().Object;

            var globalFrameMock = new Mock<IFrames>();
            globalFrameMock.SetupGet(gf => gf.UIParent).Returns(uiParent);
            Global.Frames = globalFrameMock.Object;

            var easyMenuInvokes = 0;
            NativeLuaTable menuTable = null;
            IFrame menuAnchor = null;
            IFrame expectedAnchor = null;

            var frameProviderMock = new Mock<IFrameProvider>();
            frameProviderMock.Setup(
                f => f.EasyMenu(It.IsAny<NativeLuaTable>(), It.IsAny<IFrame>(), anchorMock.Object, 0, 0, "MENU"))
                .Callback((NativeLuaTable table, IFrame frame, IFrame anchor, double x, double y, string mode) =>
                {
                    easyMenuInvokes++;
                    menuTable = table;
                    menuAnchor = frame;
                });
            frameProviderMock.Setup(
                f => f.CreateFrame(FrameType.Frame, It.IsAny<string>(), uiParent, "UIDropDownMenuTemplate"))
                .Returns(() => { 
                    expectedAnchor = new Mock<IFrame>().Object;
                    return expectedAnchor;
                });
            Global.FrameProvider = frameProviderMock.Object;

            var a1ActionInvoked = 0;

            var entitySelection = new EntitySelection();
            entitySelection["Entity type A"] = new CsLuaList<ITrackableEntity>()
            {
                MockTrackableEntity("A1", "A1Icon", () => a1ActionInvoked++),
                MockTrackableEntity("A2", "A2Icon", () => Assert.Fail("A2 should not be invoked.")),
            };
            entitySelection["Entity type B"] = new CsLuaList<ITrackableEntity>()
            {
                MockTrackableEntity("B1", "B1Icon", () => Assert.Fail("B1 should not be invoked."))
            };

            var handlerUnderTest = new EntitySelectionDropdownHandler();

            handlerUnderTest.Show(anchorMock.Object, entitySelection);

            Assert.AreEqual(1, easyMenuInvokes);
            Assert.IsNotNull(expectedAnchor);
            Assert.AreEqual(expectedAnchor, menuAnchor);
            Assert.IsNotNull(menuTable);

            Assert.AreEqual(3, menuTable.__Count());
            Assert.IsTrue(menuTable[1] is NativeLuaTable);

            var table1 = (NativeLuaTable)menuTable[1];
            Assert.AreEqual("Select an entity to track", table1["text"]);
            Assert.AreEqual(true, table1["isTitle"]);

            Assert.IsTrue(menuTable[2] is NativeLuaTable);
            var table2 = (NativeLuaTable) menuTable[2];
            Assert.AreEqual("Entity type A", table2["text"]);
            Assert.AreEqual(true, table2["hasArrow"]);
            Assert.IsTrue(table2["menuList"] is NativeLuaTable);
            
            var subMenuList2 = (NativeLuaTable) table2["menuList"];
            Assert.AreEqual(2, Table.getn(subMenuList2));
            Assert.IsTrue(subMenuList2[1] is NativeLuaTable);

            var subItem1A = (NativeLuaTable)subMenuList2[1];
            Assert.AreEqual("A1", subItem1A["text"]);
            Assert.AreEqual("A1Icon", subItem1A["icon"]);
            Assert.IsTrue(subItem1A["func"] is Action);
            Assert.AreEqual(0, a1ActionInvoked);
            ((Action) subItem1A["func"])();
            Assert.AreEqual(1, a1ActionInvoked);

            var subItem2A = (NativeLuaTable)subMenuList2[2];
            Assert.AreEqual("A2", subItem2A["text"]);
            Assert.AreEqual("A2Icon", subItem2A["icon"]);

            Assert.IsTrue(menuTable[3] is NativeLuaTable);
            var table3 = (NativeLuaTable)menuTable[3];
            Assert.AreEqual("Entity type B", table3["text"]);
            Assert.AreEqual(true, table3["hasArrow"]);
            Assert.IsTrue(table3["menuList"] is NativeLuaTable);

            var subMenuList3 = (NativeLuaTable)table3["menuList"];
            Assert.AreEqual(1, Table.getn(subMenuList3));

            var subItemB = (NativeLuaTable)subMenuList3[1];
            Assert.AreEqual("B1", subItemB["text"]);
            Assert.AreEqual("B1Icon", subItemB["icon"]);
            
        }

        private static ITrackableEntity MockTrackableEntity(string name, string icon, Action action)
        {
            var mock = new Mock<ITrackableEntity>();

            mock.SetupGet(e => e.Name).Returns(name);
            mock.SetupGet(e => e.IconPath).Returns(icon);
            mock.SetupGet(e => e.OnSelect).Returns(action);

            return mock.Object;
        }
    }
}
