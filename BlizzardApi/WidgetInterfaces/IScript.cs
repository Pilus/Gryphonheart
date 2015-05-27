namespace BlizzardApi.WidgetInterfaces
{
    using System;

    public interface IScript<T1, T2>
    {
        /// <summary>
        /// Set the function to use for a handler on this frame.
        /// </summary>
        /// <param name="self"></param>
        /// <param name="handler"></param>
        /// <param name="function"></param>
        void SetScript(T1 handler, Action<T2> function);
        void SetScript(T1 handler, Action<T2, object> function);
        void SetScript(T1 handler, Action<T2, object, object> function);
        void SetScript(T1 handler, Action<T2, object, object, object> function);
        void SetScript(T1 handler, Action<T2, object, object, object, object> function);

        /// <summary>
        /// Get the function for one of this frame's handlers.
        /// </summary>
        /// <param name="self"></param>
        /// <param name="handler"></param>
        /// <returns></returns>
        Action GetScript(T1 handler);
        /// <summary>
        /// Return true if the frame can be given a handler of the specified type (NOT whether it actually HAS one, use GetScript for that)
        /// </summary>
        /// <param name="self"></param>
        /// <param name="handler"></param>
        /// <returns></returns>
        bool HasScript(T1 handler);
        /// <summary>
        /// Hook a secure frame script.
        /// </summary>
        /// <param name="self"></param>
        /// <param name="handler"></param>
        /// <param name="function"></param>
        void HookScript(T1 handler, Action function);
    }
}
