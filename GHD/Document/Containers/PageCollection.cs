
namespace GHD.Document.Containers
{
    using BlizzardApi.WidgetInterfaces;
    using Buffer;

    using GHD.Document.Elements;
    using GHD.Document.Flags;

    public class PageCollection : ContainerBase, IPageCollection
    {
        
        public PageCollection(IFlags flags, IElementFactory elementFactory) : base(elementFactory.CreatePage(flags))
        {
        }

        public override IRegion Region
        {
            get { throw new System.NotImplementedException(); }
        }

        public override double GetWidth()
        {
            throw new System.NotImplementedException();
        }

        public override double GetHeight()
        {
            throw new System.NotImplementedException();
        }

        protected override IDimensionConstraint GetConstraint(IDimensionConstraint originalConstraint, double consumed)
        {
            throw new System.NotImplementedException();
        }

        protected override double GetDimension(IContainer child)
        {
            throw new System.NotImplementedException();
        }

        public override void Delete(IDocumentDeleter documentDeleter)
        {
            throw new System.NotImplementedException();
        }
    }
}
