namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;
    using CsLuaFramework.Wrapping;
    using EventEnums;
    using Lua;
    using WidgetEnums;

    [ProvideSelf]
    public interface IFrame : IRegion, IScript<FrameHandler, IFrame>
    {

        /// <summary>
        ///     Create and return FontString as a child of this Frame.
        /// </summary>
        /// <returns></returns>
        IFontString CreateFontString();

        IFontString CreateFontString(string name);
        IFontString CreateFontString(string name, Layer layer);
        IFontString CreateFontString(string name, Layer layer, string inheritsFrom);

        /// <summary>
        ///     Create and return Texture as a child of this Frame. Good for solid colors.
        /// </summary>
        /// <returns></returns>
        ITexture CreateTexture();

        ITexture CreateTexture(string name);
        ITexture CreateTexture(string name, Layer layer);
        ITexture CreateTexture(string name, string inheritsFrom);
        ITexture CreateTexture(string name, Layer layer, string inheritsFrom);

        /// <summary>
        ///     Create a title region for the frame if it does not have one.
        /// </summary>
        /// <returns></returns>
        IRegion CreateTitleRegion();

        /// <summary>
        ///     Disable rendering of "regions" (fontstrings, textures) in the specified draw layer.
        /// </summary>
        /// <param name="layer"></param>
        void DisableDrawLayer(Layer layer);

        /// <summary>
        ///     Enable rendering of "regions" (fontstrings, textures) in the specified draw layer.
        /// </summary>
        /// <param name="layer"></param>
        void EnableDrawLayer(Layer layer);

        /// <summary>
        ///     Set whether this frame will get keyboard input.
        /// </summary>
        /// <param name="enableFlag"></param>
        void EnableKeyboard(bool enableFlag);

        /// <summary>
        ///     Set whether this frame will get mouse input.
        /// </summary>
        /// <param name="enableFlag"></param>
        void EnableMouse(bool enableFlag);

        /// <summary>
        ///     Set whether this frame will get mouse wheel notifications.
        /// </summary>
        /// <param name="enableFlag"></param>
        void EnableMouseWheel(bool enableFlag);

        /// <summary>
        ///     Returns the first existing attribute of (prefix..name..suffix), ("*"..name..suffix), (prefix..name.."*"),
        ///     ("*"..name.."*"), (name).
        /// </summary>
        /// <param name="prefix"></param>
        /// <param name="name"></param>
        /// <param name="suffix"></param>
        object GetAttribute(string prefix, string name, string suffix);

        /// <summary>
        ///     Creates and returns a backdrop table suitable for use in SetBackdrop.
        /// </summary>
        /// <returns></returns>
        object GetBackdrop();

        /// <summary>
        ///     Gets the frame's backdrop border color (r, g, b, a).
        /// </summary>
        /// <returns></returns>
        IMultipleValues<double, double, double, double> GetBackdropBorderColor();

        /// <summary>
        ///     Gets the frame's backdrop color (r, g, b, a).
        /// </summary>
        /// <returns></returns>
        IMultipleValues<double, double, double, double> GetBackdropColor();

        /// <summary>
        ///     Get the list of "children" (frames and things derived from frames) of this frame.
        /// </summary>
        /// <returns></returns>
        IFrame[] GetChildren();

        /// <summary>
        ///     Gets the modifiers to the frame's rectangle used for clamping the frame to screen.
        /// </summary>
        /// <returns>Unknown return parameter.</returns>
        object GetClampRectInsets();

        /// <summary>
        ///     Unknown
        /// </summary>
        /// <returns>Unknown</returns>
        object GetDepth();

        /// <summary>
        ///     Returns the effective alpha of a frame.
        /// </summary>
        /// <returns></returns>
        double GetEffectiveAlpha();

        double GetEffectiveDepth();

        /// <summary>
        ///     Get the scale factor of this object relative to the root window.
        /// </summary>
        /// <returns></returns>
        double GetEffectiveScale();

        /// <summary>
        ///     Get the level of this frame.
        /// </summary>
        /// <returns></returns>
        int GetFrameLevel();

        /// <summary>
        ///     Get the strata of this frame.
        /// </summary>
        /// <returns></returns>
        FrameStrata GetFrameStrata();

        /// <summary>
        ///     Gets the frame's hit rectangle inset distances (l, r, t, b).
        /// </summary>
        /// <returns></returns>
        IMultipleValues<double, double, double, double> GetHitRectInsets();

        /// <summary>
        ///     Get the ID of this frame.
        /// </summary>
        /// <returns></returns>
        int GetID();

        /// <summary>
        ///     Gets the frame's maximum allowed resize bounds (w, h).
        /// </summary>
        /// <returns></returns>
        IMultipleValues<double, double> GetMaxResize();

        /// <summary>
        ///     Gets the frame's minimum allowed resize bounds (w, h).
        /// </summary>
        /// <returns></returns>
        IMultipleValues<double, double> GetMinResize();

        /// <summary>
        ///     Get the number of "children" (frames and things derived from frames) this frame has.
        /// </summary>
        /// <returns></returns>
        int GetNumChildren();

        /// <summary>
        ///     Return the number of "regions" (fontstrings, textures) belonging to this frame.
        /// </summary>
        /// <returns></returns>
        int GetNumRegions();

        /// <summary>
        ///     Return the "regions" (fontstrings, textures) of the frame (multiple return values) belonging to this frame.
        /// </summary>
        /// <returns></returns>
        ILayeredRegion[] GetRegions();

        /// <summary>
        ///     Get the scale factor of this object relative to its parent.
        /// </summary>
        /// <returns></returns>
        double GetScale();

        /// <summary>
        ///     Return the frame's title region.
        /// </summary>
        /// <returns></returns>
        IRegion GetTitleRegion();

        void IgnoreDepth(bool ignoreFlag);
        /// <summary>
        /// Gets whether the frame is prohibited from being dragged off screen (added 1.11)
        /// </summary>
        /// <returns></returns>
        bool IsClampedToScreen();

        /// <summary>
        /// Returns true if the given event is registered to the frame. (added 2.3)
        /// </summary>
        /// <param name="eventName"></param>
        /// <returns></returns>
        bool IsEventRegistered(string eventName);

        /// 
        bool IsIgnoringDepth();

        bool IsKeyboardEnabled();

        /// Get whether this frame will get keyboard input. (added 1.11)
        bool IsMouseEnabled();

        /// Get whether this frame will get mouse input. (added 1.11)
        bool IsMouseWheelEnabled();

        /// Get whether this frame will get mouse wheel notifications. (added 1.11)
        bool IsMovable();

        /// Determine if the frame can be moved.
        bool IsResizable();

        /// Determine if the frame can be resized.
        bool IsToplevel();

        /// Get whether the frame is set as toplevel (added 1.10.2)
        bool IsUserPlaced();

        /// Determine if this frame has been relocated by the user.
        void Lower();

        /// Lower this frame behind other frames.
        void Raise();

        /// Raise this frame above other frames.
        void RegisterAllEvents();

        /// Register this frame to receive all events (For debugging purposes only!) (added 1.11)
        void RegisterEvent(string eventName);

        void RegisterEvent(SystemEvent eventName);

        /// Indicate that this frame should be notified when event occurs.
        void RegisterForDrag(MouseButton buttonType);

        /// Inidicate that this frame should be notified of drag events for the specified buttons.
        void RegisterForDrag(MouseButton buttonType, MouseButton buttonType2);

        void SetBackdrop(NativeLuaTable backdropTable);

        /// Set the backdrop of the frame according to the specification provided.
        void SetBackdropBorderColor(double r, double g, double b);

        /// Set the frame's backdrop's border's color.
        void SetBackdropBorderColor(double r, double g, double b, double a);

        void SetBackdropColor(double r, double g, double b);

        /// Set the frame's backdrop color.
        void SetBackdropColor(double r, double g, double b, double a);

        void SetClampedToScreen(bool clamped);

        /// Set whether the frame is prohibited from being dragged off screen (added 1.11)
        void SetClampRectInsets(double left, double right, double top, double bottom);

        /// Modify the frame's rectangle used to prevent dragging offscreen.
        void SetDepth(double depth);

        void SetFrameLevel(int level);

        /// Set the level of this frame (determines which of overlapping frames shows on top).
        void SetFrameStrata(FrameStrata strata);

        /// Set the strata of this frame.
        void SetHitRectInsets(double left, double right, double top, double bottom);

        /// Set the inset distances for the frame's hit rectangle (added 1.11)
        void SetID(int id);

        /// Set the ID of this frame.
        void SetMaxResize(double maxWidth, double maxHeight);

        /// Set the maximum dimensions this frame can be resized to.
        void SetMinResize(double minWidth, double minHeight);

        /// Set the minimum dimensions this frame can be resized to.
        void SetMovable(bool isMovable);

        /// Set whether the frame can be moved.
        void SetResizable(bool isResizable);

        /// Set whether the frame can be resized.
        void SetScale(double scale);

        /// Set the scale factor of this frame relative to its parent.
        void SetToplevel(bool isTopLevel);

        /// Set whether the frame should raise itself when clicked (added 1.10.2)
        void SetUserPlaced(bool isUserPlaced);

        /// Set whether the frame has been relocated by the user, and will thus be saved in the layout cache.
        void StartMoving();

        /// Start moving this frame.
        void StartSizing(FramePoint point);

        /// Start sizing this frame using the specified anchor point.
        void StopMovingOrSizing();

        /// Stop moving and/or sizing this frame.
        void UnregisterAllEvents();

        /// Indicate that this frame should no longer be notified when any events occur.
        void UnregisterEvent(string eventName);

        /// Indicate that this frame should no longer be notified when event occurs.
    }
}