namespace GHF.Model.MSP
{
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;

    public class MSPProxy
    {
        private readonly ILibMSPWrapper msp;
        private readonly ProfileFormatter formatter;

        public MSPProxy(ProfileFormatter formatter)
        {
            this.formatter = formatter;
            this.msp = (ILibMSPWrapper) Global.Api.GetGlobal("libMSPWrapper", typeof(ILibMSPWrapper));
        }

        public void Set(Profile profile)
        {
            var fields = this.Parse(profile);
            this.msp.SetMy(fields);
            this.msp.Update();
        }

        private IMSPFields Parse(Profile profile)
        {
            var fields = this.msp.GetEmptyFieldsObj();

            fields[MSPFieldNames.GameGUID] = profile.Guid;
            fields[MSPFieldNames.GameRace] = profile.GameRace;
            fields[MSPFieldNames.GameSex] = profile.GameSex;
            fields[MSPFieldNames.GameClass] = profile.GameClass;
            fields[MSPFieldNames.Name] = this.formatter.GetFullName(profile);

            return fields;
        }
    }
}