namespace BlizzardApi.WidgetEnums
{
    
    public enum FrameHandler
    { 
        OnChar, OnDragStart, OnDragStop, OnEnter, OnEvent, OnHide, OnKeyDown, OnKeyUp, OnLeave, OnLoad,
        OnMouseDown, OnMouseUp, OnMouseWheel, OnReceiveDrag, OnShow, OnSizeChanged, OnUpdate
    }

    public enum ButtonHandler
    {
        OnClick, OnDoubleClick, PostClick, PreClick,
    }

    public enum EditBoxHandler
    {
        OnArrowPressed,
        OnCursorChanged,
        OnEditFocusGained,
        OnEditFocusLost,
        OnEnterPressed,
        OnEscapePressed,
        OnHyperlinkClick,
        OnHyperlinkEnter,
        OnHyperlinkLeave,
        OnInputLanguageChanged,
        OnSpacePressed,
        OnTabPressed,
        OnTextChanged,
        OnTextSet,
    }
}
