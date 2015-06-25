
namespace Grinder
{
    using CsLuaAttributes;
    using Lua;
    using Model.EntityAdaptor;
    using Model.EntityStorage;

    [CsLuaAddOn("Grinder", "Grinder", 62000, 
        Author = "Pilus",
        Notes = "Tracking system for items and currencies.",
        SavedVariablesPerCharacter = new []{ EntityStorage.TrackedEntitiesSavedVariableName })]
    public class GrinderAddOn : ICsLuaAddOn
    {
        public void Execute()
        {
            var model = new Model.Model(new EntityAdaptorFactory(), new EntityStorage());
            var view = new View.View(null);
            var presenter = new Presenter.Presenter(model, view);

            Core.print("Grinder loaded.");
        }
    }
}
