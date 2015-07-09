
namespace CsLuaTest.Wrap
{
    interface IInterfaceWithWrappedValues
    {
        IInterfaceWithWrappedValues GetInner();
        IInterfaceWithWrappedValues Inner { get; set; }
        string GetValue();
        bool Property { get; }
    }
}
