namespace WoWSimulator.SavedData
{
    using System.Collections.Generic;
    using BlizzardApi.Global;
    using Lua;
    using Moq;

    public class SavedDataHandler
    {
        private const bool SanitationDisabled = true; // TODO: Enable sanitation once C# serializer is implemented.

        private readonly Mock<IApi> apiMock;
        private readonly List<string> savedVariablesNames;

        public SavedDataHandler(Mock<IApi> apiMock, List<string> savedVariablesNames)
        {
            this.apiMock = apiMock;
            this.savedVariablesNames = savedVariablesNames;
        }

        public void Load(NativeLuaTable savedVariables)
        {
            foreach (var savedVariablesName in this.savedVariablesNames)
            {
                this.LoadObject(savedVariablesName, savedVariables[savedVariablesName]);
            }
        }

        private void LoadObject(string name, object obj)
        {
            if (obj == null) return;
            this.apiMock.Object.SetGlobal(name, obj);
        }

        public NativeLuaTable GetSavedVariables()
        {
            var t = new NativeLuaTable();
            foreach (var savedVariablesName in this.savedVariablesNames)
            {
                t[savedVariablesName] = this.GetVariable(savedVariablesName);
            }
            return t;
        }

        private object GetVariable(string globalName)
        {
            return SanitizeValue(this.apiMock.Object.GetGlobal(globalName));
        }

        private static object SanitizeValue(object value)
        {
            if (SanitationDisabled)
                return value;
            
            // TODO: Reenable variable sanitization when there a C# serializer is implemented.
            if (value == null) return null;
            if (value is string || value is bool || value is int || value is double || value is float) return value;
            if (!(value is NativeLuaTable)) return null;


            var t = new NativeLuaTable();
            (value as NativeLuaTable).__Foreach((k, v) =>
            {
                t[k] = SanitizeValue(v);
            });
            return t;
        }
    }
}