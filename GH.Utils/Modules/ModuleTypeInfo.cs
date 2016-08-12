
namespace GH.Utils.Modules
{
    using System;
    using System.Collections.Generic;
    using GH.Utils.Entities;

    public class ModuleTypeInfo
    {
        public bool IsSingleton { get; set; }
        public string SettingsId { get; set; }
        public List<IModule> LoadedModules { get; set; }
        public Type ModuleType { get; set; }
        public IIdObject<string> DefaultSettings { get; set; }
    }
}
