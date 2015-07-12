namespace GrinderIntegrationTests
{
    using System.Collections.Generic;
    using CsLua.Collection;
    using CsLuaTestUtils;
    using Moq;
    using WoWSimulator.ApiMocks;

    public class CurrencySystem : IApiMock
    {
        public Dictionary<int, int> Amounts = new CsLuaDictionary<int, int>();

        private int GetAmount(int id)
        {
            return this.Amounts.ContainsKey(id) ? this.Amounts[id] : 0;
        }

        public void Mock(Moq.Mock<BlizzardApi.Global.IApi> apiMock)
        {
            apiMock.Setup(api => api.GetCurrencyInfo(It.IsAny<int>()))
                .Returns((int id) =>
                {
                    if (id >= 77 && id <= 160)
                    {
                        return TestUtil.StructureMultipleValues("CurrencyName" + id, this.GetAmount(id), "iconPath" + id,
                            7, 100, 1000, id < 100);
                    }
                    return TestUtil.StructureMultipleValues("", 0, "", 0, 0, 0, false);
                });
        }
    }
}