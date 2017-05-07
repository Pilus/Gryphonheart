namespace GHD.UnitTests.Document.Groups.LayoutStrategies
{
    using GHD.Document.Elements;
    using GHD.Document.Groups;
    using GHD.Document.Groups.LayoutStrategies;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using Moq;

    [TestClass]
    public class BackflowLayoutUpdateStrategyTests
    {
        private BackflowLayoutUpdateStrategy strategyUnderTest;

        private Mock<ILayoutUpdateStrategy> strategyOnPreviousElementMock;

        private Mock<IGroup> groupMock;
        private Mock<IElement> firstElementMock;

        [TestInitialize]
        public void TestInitialize()
        {
            this.strategyUnderTest = new BackflowLayoutUpdateStrategy();
            this.strategyOnPreviousElementMock = new Mock<ILayoutUpdateStrategy>();
            this.strategyUnderTest.StrategyExecutedOnPreviousGroup = this.strategyOnPreviousElementMock.Object;

            this.groupMock = new Mock<IGroup>();
            this.firstElementMock = new Mock<IElement>();
            this.groupMock.SetupGet(group => group.FirstElement).Returns(this.firstElementMock.Object);
        }

        [TestMethod]
        public void UpdateLayoutExecutesStrategyOnPreviousTest()
        {
            var previousElementMock = new Mock<IElement>();
            this.firstElementMock.SetupGet(element => element.Prev).Returns(previousElementMock.Object);

            var previousGroupMock = new Mock<IGroup>();
            previousElementMock.SetupGet(element => element.Group).Returns(previousGroupMock.Object);
            previousElementMock.SetupGet(element => element.SizeChanged).Returns(true);

            this.strategyUnderTest.UpdateLayout(this.groupMock.Object);

            this.strategyOnPreviousElementMock.Verify(strategy => strategy.UpdateLayout(previousGroupMock.Object), Times.Once);
        }

        [TestMethod]
        public void UpdateLayoutDoesNotExecuteStrategyWithNoPreviousTest()
        {
            this.strategyUnderTest.UpdateLayout(this.groupMock.Object);

            this.strategyOnPreviousElementMock.Verify(strategy => strategy.UpdateLayout(It.IsAny<IGroup>()), Times.Never);
        }

        [TestMethod]
        public void UpdateLayoutDoesNotExecuteStrategyWithPreviousNotChangedTest()
        {
            var previousElementMock = new Mock<IElement>();
            this.firstElementMock.SetupGet(element => element.Prev).Returns(previousElementMock.Object);

            this.strategyUnderTest.UpdateLayout(this.groupMock.Object);

            this.strategyOnPreviousElementMock.Verify(strategy => strategy.UpdateLayout(It.IsAny<IGroup>()), Times.Never);
        }
    }
}