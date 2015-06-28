namespace WoWSimulator.UISimulation.UiObjects
{
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class FontString : Region, IFontString
    {
        private string text;

        public FontString(UiInitUtil util, string objectType, FontStringType frameType, IRegion parent)
            : base(util, objectType, frameType, parent)
        {
            if (!string.IsNullOrEmpty(frameType.inherits))
            {
                this.ApplyType((FontStringType)util.GetTemplate(frameType.inherits));
            }
            this.ApplyType(frameType);
        }

        private void ApplyType(FontStringType type)
        {
            
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
            throw new System.NotImplementedException();
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
            throw new System.NotImplementedException();
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
    }
}