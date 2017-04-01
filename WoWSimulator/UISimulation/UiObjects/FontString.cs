namespace WoWSimulator.UISimulation.UiObjects
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using XMLHandler;

    public class FontString : Region, IFontString
    {
        private string text;
        private string font;
        private double fontHeight;
        private DrawLayer layer;

        public FontString(UiInitUtil util, string objectType, FontStringType type, IRegion parent)
            : base(util, objectType, type, parent)
        {
            if (!string.IsNullOrEmpty(type.inherits))
            {
                this.ApplyType((FontStringType)util.GetTemplate(type.inherits));
            }
            this.ApplyType(type);
        }

        private void ApplyType(FontStringType type)
        {
            this.text = type.text;
            this.font = type.font;
        }

        public bool CanNonSpaceWrap()
        {
            throw new NotImplementedException();
        }

        public double GetStringHeight()
        {
            throw new NotImplementedException();
        }

        public double GetStringWidth()
        {
            return this.text.Length * this.fontHeight * 0.6; // Rough approximation, font independent.
        }

        public string GetText()
        {
            return this.text ?? string.Empty;
        }

        public void SetAlphaGradient(int start, int length)
        {
            throw new NotImplementedException();
        }

        public void SetFormattedText(string formatstring, object arg1)
        {
            throw new NotImplementedException();
        }

        public void SetNonSpaceWrap(object wrapFlag)
        {
            //throw new System.NotImplementedException();
        }

        public void SetText(string text)
        {
            this.text = text;
        }

        public void SetTextHeight(double pixelHeight)
        {
            throw new NotImplementedException();
        }

        public void SetWordWrap(bool enable)
        {
            //throw new System.NotImplementedException();
        }

        public void SetFont(string path, double height)
        {
            this.SetFont(path, height, null);
        }

        public void SetFont(string path, double height, string flags)
        {
            this.font = path;
            this.fontHeight = height;
        }

        public void SetJustifyH(JustifyH justifyH)
        {
            //throw new System.NotImplementedException();
        }

        public void SetJustifyV(JustifyV justifyV)
        {
            throw new NotImplementedException();
        }

        public void SetTextColor(double r, double g, double b)
        {
            //throw new System.NotImplementedException();
        }

        public void SetTextColor(double r, double g, double b, double a)
        {
            throw new NotImplementedException();
        }

        public DrawLayer GetDrawLayer()
        {
            return this.layer;
        }

        public void SetDrawLayer(DrawLayer layer)
        {
            this.layer = layer;
        }

        public void SetVertexColor(double r, double g, double b)
        {
            throw new NotImplementedException();
        }

        public void SetVertexColor(double r, double g, double b, double alpha)
        {
            throw new NotImplementedException();
        }
    }
}