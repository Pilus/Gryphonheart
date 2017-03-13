
namespace GHD.Document
{
    using System;
    using System.Collections.Generic;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Buffer;
    using Containers;
    using Data;
    using GHD.Document.Data.Default;
    using GHD.Document.Elements;
    using GHD.Document.Flags;
    using KeyboardInput;
    using BlizzardApi.Global;

    public class Document
    {
        private static int documentCount;

        private readonly IButton frame;
        private readonly IKeyboardInputProvider keyboardInput;
        private readonly ICursor cursor;
        private readonly IElementFactory elementFactory;
        private readonly ITextScoper textScoper;
        private IPageCollection pageCollection;

        public Document(IKeyboardInputProvider keyboardInput, ICursor cursor, IElementFactory elementFactory, ITextScoper textScoper)
            : this(keyboardInput, cursor, elementFactory, textScoper, null)
        {
        }

        public Document(IKeyboardInputProvider keyboardInput, ICursor cursor, IElementFactory elementFactory, ITextScoper textScoper, IDocumentData data)
        {
            documentCount++;
            this.keyboardInput = keyboardInput;
            this.keyboardInput.RegisterCallback(this.HandleKeyboardInput);
            this.cursor = cursor;
            this.elementFactory = elementFactory;
            this.textScoper = textScoper;

            this.frame = (IButton)Global.FrameProvider.CreateFrame(FrameType.Button, "GHD_Document" + documentCount);

            if (data != null)
            {
                this.Load(data);
            }
            else
            {
                this.New();
            }
        }

        public IRegion Region
        {
            get { return this.frame; }
        }

        private void New()
        {
            var flags = FlagsManager.LoadFlags(Defaults.DocumentWideFlags);
            this.pageCollection = this.elementFactory.CreatePageCollection(flags); // TODO: Set back to page collection
            this.pageCollection.Region.SetParent(this.frame);
            this.pageCollection.Region.SetPoint(FramePoint.TOPLEFT, this.frame, FramePoint.TOPLEFT, 20, -20);
            this.pageCollection.SetCursor(false, this.cursor);
        }

        private void Load(IDocumentData data)
        {
            var flags = FlagsManager.LoadFlags(DefaultMerger.AddDefaults(data.DocumentWideFlags));
            this.pageCollection = this.elementFactory.CreatePageCollection(flags);
            this.pageCollection.SetCursor(false, this.cursor);
        }

        private static readonly Dictionary<EditInputType, NavigationType> NavigationTypeMap = new Dictionary<EditInputType, NavigationType>()
        {
            {EditInputType.Up, NavigationType.Up},
            {EditInputType.Down, NavigationType.Down},
            {EditInputType.Left, NavigationType.Left},
            {EditInputType.Right, NavigationType.Right},
            {EditInputType.Home, NavigationType.Home},
            {EditInputType.End, NavigationType.End},
        };

        private void HandleKeyboardInput(EditInputType type, string detail)
        {
            if (NavigationTypeMap.ContainsKey(type))
            {
                this.pageCollection.NavigateCursor(NavigationTypeMap[type]);
                return;
            }

            if (type == EditInputType.Escape)
            {
                this.keyboardInput.Stop();
                return;
            }

            if (type == EditInputType.Input)
            {
                var buffer = new DocumentBuffer(this.elementFactory, this.textScoper);
                buffer.Append(detail, this.pageCollection.GetCurrentFlags());
                this.pageCollection.Insert(buffer, null);
                return;
            }


            throw new Exception("Unhandled input type: " + type);
        }

    }
}
