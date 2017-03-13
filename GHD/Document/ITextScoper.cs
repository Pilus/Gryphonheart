namespace GHD.Document
{
    public interface ITextScoper
    {
        string GetFittingText(string fontPath, int fontSize, string text, double width);
        double GetWidth(string fontPath, int fontSize, string text);
    }
}