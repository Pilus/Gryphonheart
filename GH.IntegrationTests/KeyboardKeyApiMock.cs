namespace GH.IntegrationTests
{
    using BlizzardApi.Global;

    using Moq;

    using WoWSimulator.ApiMocks;
    public class KeyboardKeyApiMock : IApiMock
    {
        public bool ShiftKeyDown { get; set; }

        public void Mock(Mock<IApi> apiMock)
        {
            apiMock.Setup(a => a.IsShiftKeyDown()).Returns(() => this.ShiftKeyDown);
        }
    }
}