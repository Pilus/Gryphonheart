﻿
namespace GHD.Document.Containers
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Buffer;

    using GHD.Document.Elements;
    using GHD.Document.Flags;

    public class PageCollection : ContainerBase, IPageCollection
    {
        private readonly IFrame frame;

        public PageCollection(IFlags flags, IElementFactory elementFactory) : base(elementFactory.CreatePage(flags))
        {
            this.frame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, GenerateFrameName("GHD_DocumentPageCollection"));
        }

        public override IRegion Region
        {
            get
            {
                return this.frame;
            }
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
            return originalConstraint;
        }

        protected override double GetDimension(IContainer child)
        {
            throw new System.NotImplementedException();
        }

        public override void Delete(IDocumentDeleter documentDeleter)
        {
            throw new System.NotImplementedException();
        }

        public override Position GetCursorPosition()
        {
            return this.CurrentCursorChild.GetCursorPosition();
        }
    }
}
