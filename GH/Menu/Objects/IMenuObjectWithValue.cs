namespace GH.Menu.Objects
{
    public interface IMenuObjectWithValue : IMenuObject
    {
        object GetValue();
        void SetValue(object value);
    }
}
