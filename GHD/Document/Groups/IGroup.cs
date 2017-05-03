namespace GHD.Document.Groups
{
    using GHD.Document.Elements;

    public interface IGroup
    {
        void UpdateLayout();

        IElement FirstElement { get; set; }
        IElement LastElement { get; set; }
    }
}