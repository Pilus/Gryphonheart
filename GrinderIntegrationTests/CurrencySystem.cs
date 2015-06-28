namespace GrinderIntegrationTests
{
    using CsLuaTestUtils;
    using Moq;
    using WoWSimulator.ApiMocks;

    public class CurrencySystem : IApiMock
    {

        public void Mock(Moq.Mock<BlizzardApi.Global.IApi> apiMock)
        {
            apiMock.Setup(api => api.GetCurrencyInfo(It.IsInRange(77, 160, Range.Inclusive)))
                .Returns((int id) => TestUtil.StructureMultipleValues("CurrencyName" + id, id == 80 ? 55 : 10, "iconPath" + id, 7, 100, 1000, id < 100));
        }
    }
}