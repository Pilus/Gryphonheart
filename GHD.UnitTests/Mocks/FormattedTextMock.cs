namespace GHD.UnitTests.Mocks
{
    using GHD.Document.Elements;
    using System;
    using GHD.Document.Buffer;
    using GHD.Document.Containers;
    using GHD.Document.Flags;
    using BlizzardApi.WidgetInterfaces;

    class FormattedTextMock : IFormattedText
    {
        public bool AllowZeroPosition { get; set; }
        public Flags Flags { get; set; }

        public string Text { get; private set; }

        public IRegion Region => throw new NotImplementedException();

        public IContainer Prev { get; set; }
        public IContainer Next { get; set; }

        public void ClearCursor()
        {
            throw new NotImplementedException();
        }

        public void ClearHightLight()
        {
            throw new NotImplementedException();
        }

        public void Delete(IDocumentDeleter documentDeleter)
        {
            throw new NotImplementedException();
        }

        public IElement GetCurrentElement()
        {
            throw new NotImplementedException();
        }

        public IFlags GetCurrentFlags()
        {
            throw new NotImplementedException();
        }

        public double GetHeight()
        {
            throw new NotImplementedException();
        }

        public int GetLength()
        {
            throw new NotImplementedException();
        }

        public double GetWidth()
        {
            throw new NotImplementedException();
        }

        public void Insert(IDocumentBuffer documentBuffer, IDimensionConstraint dimensionConstraint)
        {
            throw new NotImplementedException();
        }

        public bool NavigateCursor(NavigationType type)
        {
            throw new NotImplementedException();
        }

        public void SetCursor(bool inEnd, ICursor cursor)
        {
            throw new NotImplementedException();
        }

        public void SetHightLight(int hightLightStart, int highLightEnd)
        {
            throw new NotImplementedException();
        }

        public void SetText(string newText)
        {
            this.Text = newText;
        }

        public void UpdateLayout(int position, IDocumentBuffer documentBuffer)
        {
            throw new NotImplementedException();
        }

        public Position GetCursorPosition()
        {
            throw new NotImplementedException();
        }
    }
}
