namespace WoWSimulator.UISimulation.UiObjects
{
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class FontString : Region, IFontString
    {
        private string text;
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
        }

        public bool CanNonSpaceWrap()
        {
            throw new System.NotImplementedException();
        }

        public double GetStringHeight()
        {
            throw new System.NotImplementedException();
        }

        public double GetStringWidth()
        {
            throw new System.NotImplementedException();
        }

        public string GetText()
        {
            return this.text;
        }

        public void SetAlphaGradient(int start, int length)
        {
            throw new System.NotImplementedException();
        }

        public void SetFormattedText(string formatstring, object arg1)
        {
            throw new System.NotImplementedException();
        }

        public void SetNonSpaceWrap(object wrapFlag)
        {
            throw new System.NotImplementedException();
        }

        public void SetText(string text)
        {
            this.text = text;
        }

        public void SetTextHeight(double pixelHeight)
        {
            throw new System.NotImplementedException();
        }

        public void SetWordWrap(bool enable)
        {
            throw new System.NotImplementedException();
        }

        public void SetFont(string path, double height)
        {
            throw new System.NotImplementedException();
        }

        public void SetFont(string path, double height, string flags)
        {
            throw new System.NotImplementedException();
        }

        public void SetJustifyH(JustifyH justifyH)
        {
            throw new System.NotImplementedException();
        }

        public void SetJustifyV(JustifyV justifyV)
        {
            throw new System.NotImplementedException();
        }

        public void SetTextColor(double r, double g, double b)
        {
            throw new System.NotImplementedException();
        }

        public void SetTextColor(double r, double g, double b, double a)
        {
            throw new System.NotImplementedException();
        }

        public DrawLayer GetDrawLayer()
        {
            return this.layer;
        }

        public void SetDrawLayer(DrawLayer layer)
        {
            this.layer = layer;
        }

        public void SetVertexColor(float r, float g, float b)
        {
            throw new System.NotImplementedException();
        }

        public void SetVertexColor(float r, float g, float b, float alpha)
        {
            throw new System.NotImplementedException();
        }
    }
}