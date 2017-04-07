namespace GHD.Document.AltElements
{
    public interface ISplitableElement : IElement
    {
        ISplitableElement SplitFromFront(double width);

        ISplitableElement SplitFromEnd(double width);
    }
}