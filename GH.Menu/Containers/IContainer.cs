namespace GH.Menu.Containers
{
    using GH.Menu.Objects;

    public interface IContainer : IElement
    {
        void SetValue(string id, object value);
        object GetValue(string id);
        IMenuObject GetFrameById(string id);
    }

    public interface IContainer<T> : IContainer where T: IMenuRegion
    {
        void AddElement(T element);
        void AddElement(T element, int index);
        void RemoveElement(int index);
        int GetNumElements();
        T GetElement(int index);
    }
}
