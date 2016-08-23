namespace GH.IntegrationTests
{
    using BlizzardApi.Global;

    using Moq;

    using TestUtils;

    using WoWSimulator.ApiMocks;

    public class CursorApiMock : IApiMock
    {
        private double xPosition = 0;

        private double yPosition = 0;

        public void SetPosition(double x, double y)
        {
            this.xPosition = x;
            this.yPosition = y;
        }

        public void Mock(Mock<IApi> apiMock)
        {
            apiMock.Setup(a => a.GetCursorPosition())
                .Returns(TestUtil.StructureMultipleValues(this.xPosition, this.yPosition));
        }
    }
}