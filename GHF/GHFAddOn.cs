namespace GHF
{
    using BlizzardApi.Global;
    using CsLuaFramework;
    using CsLuaFramework.Attributes;
    using CsLuaFramework.Wrapping;
    using Lua;
    using Model;

    [CsLuaAddOn("GHF", "Gryphonheart Flags", 60200, Author = "The Gryphonheart Team", Notes = "Lets you specify roleplay details about your character, such as last name and appearance. Also  displays the details of other roleplayers.", Dependencies = new[] { "GH"}, SavedVariables = new[] { ModelProvider.SavedAccountProfiles })]
    public class GHFAddOn : ICsLuaAddOn
    {
        public void Execute()
        {
            // Check for existing MSP RP AddOn.
            if (Global.Api.GetGlobal("msp_RPAddOn") != null)
            {
                Core.print("GHF stopped loading due to conflict with another MSP RP AddOn:", Global.Api.GetGlobal("msp_RPAddOn"));
            }
            Global.Api.SetGlobal("msp_RPAddOn", "GHF");

            var model = new ModelProvider(new Serializer(), new Wrapper());
        }
    }
}