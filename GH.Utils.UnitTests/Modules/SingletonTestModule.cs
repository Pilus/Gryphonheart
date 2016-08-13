
namespace GH.Utils.UnitTests.Modules
{
    using System;
    using GH.Utils.Entities;
    using GH.Utils.Modules;
    using Moq;

    public class SingletonTestModule : SingletonModule
    {
        public const string SettingId = "SingletonId";
        public Mock<IIdEntity<string>> DefaultSettings;

        public SingletonTestModule()
        {
            this.DefaultSettings = new Mock<IIdEntity<string>>();
            this.DefaultSettings.Setup(s => s.Id).Returns(SettingId);
        }
    }
}
