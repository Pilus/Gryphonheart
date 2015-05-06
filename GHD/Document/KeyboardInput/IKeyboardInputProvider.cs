namespace GHD.Document.KeyboardInput
{
    using System;

    public interface IKeyboardInputProvider
    {
        void RegisterCallback(Action<EditInputType, string> callback);

        void Start();

        void Stop();

        void SetHightlightedText(string text);
    }
}