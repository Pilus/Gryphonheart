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

    public interface IMultipleValues<T1, T2, T3, T4, T5>
    {
        T1 Value1 { get; }
        T2 Value2 { get; }
        T3 Value3 { get; }
        T4 Value4 { get; }
        T5 Value5 { get; }
    }

    public interface IMultipleValues<T1, T2, T3, T4, T5, T6>
    {
        T1 Value1 { get; }
        T2 Value2 { get; }
        T3 Value3 { get; }
        T4 Value4 { get; }
        T5 Value5 { get; }
        T6 Value6 { get; }
    }

    public interface IMultipleValues<T1, T2, T3, T4, T5, T6, T7>
    {
        T1 Value1 { get; }
        T2 Value2 { get; }
        T3 Value3 { get; }
        T4 Value4 { get; }
        T5 Value5 { get; }
        T6 Value6 { get; }
        T7 Value7 { get; }
    }

    public interface IMultipleValues<T1, T2, T3, T4, T5, T6, T7, T8>
    {
        T1 Value1 { get; }
        T2 Value2 { get; }
        T3 Value3 { get; }
        T4 Value4 { get; }
        T5 Value5 { get; }
        T6 Value6 { get; }
        T7 Value7 { get; }
        T8 Value8 { get; }
    }
}