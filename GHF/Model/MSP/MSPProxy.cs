namespace GHF.Model.MSP
{
    using AdditionalFields;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CsLua.Collection;
    using Lua;

    public class MSPProxy
    {
        private readonly ILibMSPWrapper msp;
        private readonly ProfileFormatter formatter;
        private readonly string addOnsVersion;
        private readonly SupportedFields supportedFields;

        public MSPProxy(ProfileFormatter formatter, string ghAddOnVersion, SupportedFields supportedFields)
        {
            this.formatter = formatter;
            this.addOnsVersion = "GH/" + ghAddOnVersion;
            this.supportedFields = supportedFields;
            this.msp = (ILibMSPWrapper) Global.Api.GetGlobal("libMSPWrapper", typeof(ILibMSPWrapper));
        }

        public void Set(Profile profile)
        {
            var fields = this.Parse(profile);
            this.msp.SetMy(fields);
            this.msp.Update();
        }

        public PublicProfile Get(string playerName)
        {
            var fields = this.msp.GetOther(playerName);
            if (fields == null)
            {
                return null;
            }

            return null;
        }

        public void Request(string playerName, CsLuaList<string> fields)
        {
            this.msp.Request(playerName, fields.ToNativeLuaTable());
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

            foreach (var additionalField in profile.AdditionalFields)
            {
                var fieldsMeta = this.supportedFields.Fields.FirstOrDefault(f => f.Id.Equals(additionalField.Key));
                if (fieldsMeta == null)
                {
                    throw new MspProxyException("The field {0} is not mapable.", additionalField.Key);
                }

                if (additionalField.Value != null)
                {
                    fields[fieldsMeta.MspMapping] = additionalField.Value;
                }
            }

            return fields;
        }
    }
}