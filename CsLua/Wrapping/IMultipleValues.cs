namespace CsLua.Wrapping
{
    public interface IMultipleValues<T1>
    {
        T1 Value1 { get; }
    }

    public interface IMultipleValues<T1, T2>
    {
        T1 Value1 { get; }
        T2 Value2 { get; }
    }

    public interface IMultipleValues<T1, T2, T3>
    {
        T1 Value1 { get; }
        T2 Value2 { get; }
        T3 Value3 { get; }
    }

    public interface IMultipleValues<T1, T2, T3, T4>
    {
        T1 Value1 { get; }
        T2 Value2 { get; }
        T3 Value3 { get; }
        T4 Value4 { get; }
    }
}