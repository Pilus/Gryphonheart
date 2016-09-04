
namespace GH.IntegrationTests
{
    using System;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using Tests;

    using WoWSimulator;

    [TestClass]
    public class QuickButtonUsageTests
    {
        [TestMethod]
        public void QuickButtonPositionOverMultipleSessions()
        {
            
            var cursorApiMock = new CursorApiMock();
            var keyboardKeyMock = new KeyboardKeyApiMock();
            var session = new SessionBuilder()
                .WithScreenDimensions(800, 600)
                .WithApiMock(cursorApiMock)
                .WithApiMock(keyboardKeyMock)
                .WithGH()
                .Build();

            session.RunStartup();
            
            var ghTestable = new GHAddOnTestable(session);

            var buttonLocation = ghTestable.GetMainButtonLocation();
            var distToExpected = GetDist(buttonLocation.Item1, buttonLocation.Item2, 600, 450);
            Assert.IsTrue(distToExpected < 30, $"The main button was not located as expected. Distance from actual to expected: {distToExpected}.");
            
            ghTestable.MouseOverMainButton();
            cursorApiMock.SetPosition(600, 450);
            keyboardKeyMock.ShiftKeyDown = true;
            ghTestable.StartDragMainButton();
            session.RunUpdate();
            cursorApiMock.SetPosition(550, 300);
            session.RunUpdate();
            cursorApiMock.SetPosition(500, 100);
            session.RunUpdate();
            ghTestable.StopDragMainButton();
            keyboardKeyMock.ShiftKeyDown = false;

            var buttonLocationAfterMove = ghTestable.GetMainButtonLocation();
            var distToExpectedAfterMove = GetDist(buttonLocationAfterMove.Item1, buttonLocationAfterMove.Item2, 500, 100);
            Assert.IsTrue(distToExpectedAfterMove < 30, $"The main button was not located as expected. Distance from actual to expected: {distToExpectedAfterMove}.");

            var savedVars = session.GetSavedVariables();
            
            var cursorApiMock2 = new CursorApiMock();
            var session2 = new SessionBuilder()
                .WithScreenDimensions(800, 600)
                .WithApiMock(cursorApiMock2)
                .WithSavedVariables(savedVars)
                .WithGH()
                .Build();

            var ghTestable2 = new GHAddOnTestable(session2);

            var buttonLocation2 = ghTestable2.GetMainButtonLocation();
            var distToExpected2 = GetDist(buttonLocation2.Item1, buttonLocation2.Item2, 500, 100);
            Assert.IsTrue(distToExpected2 < 30, $"The main button was not located as expected. Distance from actual to expected: {distToExpected2}.");
        }

        private static double GetDist(double ax, double ay, double bx, double by)
        {
            var x = Math.Abs(ax - bx);
            var y = Math.Abs(ay - by);
            return Math.Sqrt((x * x) + (y * y));
        }
    }
}
