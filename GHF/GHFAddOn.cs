namespace GHF
{
    using CsLuaAttributes;
    using Lua;
    using Model;

    [CsLuaAddOn("GHF", "Gryphonheart Flags", 60200, Author = "The Gryphonheart Team", Notes = "Lets you specify roleplay details about your character, such as last name and appearance. Also  displays the details of other roleplayers.", Dependencies = new[] { "GH"}, SavedVariables = new[] { ModelProvider.SavedAccountProfiles })]
    public class GHFAddOn : ICsLuaAddOn
    {
        public void Execute()
        {
            var model = new ModelProvider();
        }
    }
}