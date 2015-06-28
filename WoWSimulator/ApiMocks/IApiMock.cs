namespace WoWSimulator.ApiMocks
{
    using BlizzardApi.Global;
    using Moq;

    public interface IApiMock
    {
        void Mock(Mock<IApi> apiMock);
    }
}