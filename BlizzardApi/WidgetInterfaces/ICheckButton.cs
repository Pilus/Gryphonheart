namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;

    [ProvideSelf]
    public interface ICheckButton : IButton
    {
        /// <summary>
        /// Get the status of the checkbox.
        /// </summary>
        /// <returns></returns>
        bool GetChecked();

        /// <summary>
        /// Get the texture used for a checked box(added 1.11)
        /// </summary>
        /// <returns></returns>
        string GetCheckedTexture();

        /// <summary>
        /// Get the texture used for a disabled checked box(added 1.11)
        /// </summary>
        /// <returns></returns>
        string GetDisabledCheckedTexture();

        /// <summary>
        /// Set the status of the checkbox.
        /// </summary>
        /// <param name="state"></param>
        void SetChecked(bool state);

        /// <summary>
        /// Set the texture to use for a checked box.
        /// </summary>
        /// <param texture=""></param>
        void SetCheckedTexture(string texture);

        /// <summary>
        /// Set the texture to use for a disabled but checked box.
        /// </summary>
        /// <param name="texture"></param>
        void SetDisabledCheckedTexture(string texture);
    }
}
