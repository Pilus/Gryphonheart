
namespace BlizzardApi.WidgetInterfaces
{
    public interface IIndexer<TKey, TValue>
    {
        TValue this[TKey key] { get; set; }
    }
}
