
namespace GH.Utils.UnitTests.Modules
{
    using System;
    using GH.Utils.Entities;
    using GH.Utils.Modules;
    using Moq;

    public class SingletonTestModule : SingletonModule
    {
        public string SettingId = "SingletonId";
        public Mock<IIdObject<string>> DefaultSettings;

        public SingletonTestModule()
        {
            this.DefaultSettings = new Mock<IIdObject<string>>();
            this.DefaultSettings.Setup(s => s.Id).Returns(this.SettingId);
        }

        /// <summary>
        /// Gets a idObject that containing the default settings of the module.
        /// </summary>
        /// <returns>The settings.</returns>
        public override IIdObject<string> GetDefaultSettings()
        {
            return this.DefaultSettings.Object;
        }

        public IIdObject<string> AppliedSettings;

        /// <summary>
        /// Applies a settings object to the module.
        /// </summary>
        /// <param name="settings">The settings object as an IdObject with string as id.</param>
        public override void ApplySettings(IIdObject<string> settings)
        {
            this.AppliedSettings = settings;
        }
    }
}
