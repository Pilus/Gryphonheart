
namespace GHD.Document
{
    using System;
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Buffer;
    using Containers;
    using CsLua;
    using CsLua.Collection;
    using Data;
    using GHD.Document.Data.Default;
    using GHD.Document.Elements;
    using GHD.Document.Flags;
    using KeyboardInput;

    public class Document
    {
        private static int documentCount;

        private readonly IButton frame;
        private readonly IKeyboardInputProvider keyboardInput;
        private readonly ICursor cursor;
        private IContainer pageCollection;

        public Document(IKeyboardInputProvider keyboardInput, ICursor cursor)
            : this(keyboardInput, cursor, null)
        {
        }

        public Document(IKeyboardInputProvider keyboardInput, ICursor cursor, IDocumentData data)
        {
            documentCount++;
            this.keyboardInput = keyboardInput;
            this.keyboardInput.RegisterCallback(this.HandleKeyboardInput);
            this.cursor = cursor;

            this.frame = (IButton)FrameUtil.FrameProvider.CreateFrame(FrameType.Button, "GHD_Document" + documentCount);

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
            this.pageCollection = new Page(flags, Defaults.PageProperties); // TODO: Set back to page collection
            this.pageCollection.Region.SetParent(this.frame);
            this.pageCollection.Region.SetPoint(FramePoint.TOPLEFT, this.frame, FramePoint.TOPLEFT, 20, -20);
            this.pageCollection.SetCursor(false, this.cursor);
        }

        private void Load(IDocumentData data)
        {
            var flags = FlagsManager.LoadFlags(DefaultMerger.AddDefaults(data.DocumentWideFlags));
            this.pageCollection = new PageCollection(flags);
            this.pageCollection.SetCursor(false, this.cursor);
        }

        private static readonly CsLuaDictionary<EditInputType, NavigationType> NavigationTypeMap = new CsLuaDictionary<EditInputType, NavigationType>()
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
                var buffer = new DocumentBuffer();
                buffer.Append(detail, this.pageCollection.GetCurrentFlags());
                this.pageCollection.Insert(buffer, null);
                return;
            }


            throw new CsException("Unhandled input type: " + type);
        }

    }
}
