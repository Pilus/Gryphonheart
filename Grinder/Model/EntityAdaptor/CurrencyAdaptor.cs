namespace Grinder.Model.EntityAdaptor
{
    using CsLua.Collection;
    using Grinder.Model.Entity;
    using BlizzardApi.Global;

    public class CurrencyAdaptor : IEntityAdaptor
    {
        private const int ThresholdForContinuousMissingCurrency = 100;
        public CsLuaList<IEntity> GetAvailableEntities()
        {
            var list = new CsLuaList<IEntity>();

            var id = 1;
            var continuousNullCount = 0;
            while (continuousNullCount < ThresholdForContinuousMissingCurrency)
            {
                var currencyInfo = Global.Api.GetCurrencyInfo(id);

                if (currencyInfo != null)
                {
                    var currency = new Currency(id, currencyInfo);
                    if (currency.IsDiscovered)
                    {
                        list.Add(currency);
                    }

                    continuousNullCount = 0;
                }
                else
                {
                    continuousNullCount++;
                }
                id++;
            }

            return list;
        }

        public int GetCurrentAmount(int entityId)
        {
            return Global.Api.GetCurrencyInfo(entityId).Value2;
        }
    }
}
