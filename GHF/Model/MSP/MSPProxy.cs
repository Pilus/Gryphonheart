namespace GHF.Model.MSP
{
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;

    public class MSPProxy
    {
        private readonly ILibMSPWrapper msp;
        private readonly ProfileFormatter formatter;
        private readonly string addOnsVersion;

        public MSPProxy(ProfileFormatter formatter, string ghAddOnVersion)
        {
            this.formatter = formatter;
            this.addOnsVersion = "GH/" + ghAddOnVersion;
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

            fields[MSPFieldNames.ProtocolVersion] = "1";
            fields[MSPFieldNames.AddOnVersions] = this.addOnsVersion;
            fields[MSPFieldNames.GameGUID] = profile.Guid;
            fields[MSPFieldNames.GameRace] = profile.GameRace;
            fields[MSPFieldNames.GameSex] = profile.GameSex;
            fields[MSPFieldNames.GameClass] = profile.GameClass;
            fields[MSPFieldNames.Name] = this.formatter.GetFullName(profile);
            fields[MSPFieldNames.PhysicalDescription] = profile.Appearance;

            return fields;
        }
    }
}