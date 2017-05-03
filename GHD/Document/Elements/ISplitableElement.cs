namespace GHD.Document.Elements
{
    public interface ISplitableElement : IElement
    {
        ISplitableElement SplitFromFront(double width);

        ISplitableElement SplitFromEnd(double width);

        bool TryMergeIntoFront();
    }
}