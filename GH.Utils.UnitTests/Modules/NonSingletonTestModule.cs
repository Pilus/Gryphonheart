namespace GH.Utils.UnitTests.Modules
{
    using GH.Utils.Entities;
    using GH.Utils.Modules;
    using Moq;

    public class NonSingletonTestModule : NonSingletonModule
    {
        public const string SettingId = "NonSingletonId";
        public Mock<IIdEntity<string>> DefaultSettings;

        public NonSingletonTestModule()
        {
            this.DefaultSettings = new Mock<IIdEntity<string>>();
            this.DefaultSettings.Setup(s => s.Id).Returns(SettingId);
        }
    }
}
