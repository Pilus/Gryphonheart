
namespace GH.Utils.UnitTests.Modules
{
    using System;
    using GH.Utils.Entities;
    using GH.Utils.Modules;
    using Moq;

    public class SingletonTestModule2 : SingletonModule
    {
        public const string SettingId = "Singleton2Id";
        public Mock<IIdEntity<string>> DefaultSettings;

        public SingletonTestModule2()
        {
            this.DefaultSettings = new Mock<IIdEntity<string>>();
            this.DefaultSettings.Setup(s => s.Id).Returns(SettingId);
        }
    }
}
