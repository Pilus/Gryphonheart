
namespace GH.Settings
{
    public class Setting : ISetting
    {
        public Setting(SettingIds id, object value)
        {
            this.Id = id;
            this.Value = value;
        }

        public object Value
        {
            get;
            set;
        }

        public SettingIds Id
        {
            get;
            private set;
        }
    }
}
